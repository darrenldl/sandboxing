type arg =
  | Unshare_user
  | Unshare_user_try
  | Unshare_ipc
  | Unshare_pid
  | Unshare_net
  | Unshare_uts
  | Unshare_cgroup
  | Unshare_cgroup_try
  | Unshare_all
  | Uid of int option
  | Gid of int option
  | Hostname of string
  | Chdir of string
  | Setenv of string * string
  | Unsetenv of string
  | Lock_file of string
  | Bind of string * string option
  | Bind_try of string * string option
  | Dev_bind of string * string option
  | Dev_bind_try of string * string option
  | Ro_bind of string * string option
  | Ro_bind_try of string * string option
  | Remount_ro of string
  | Proc of string
  | Dev of string
  | Tmpfs of string
  | Dir of string
  | Symlink of string * string option
  | Seccomp of string
  | New_session

type profile = {
  name : string;
  cmd : string;
  home_jail_dir : string option;
  syscall_blacklist : Seccomp_bpf.syscall list;
  args : arg list;
}

let get_jail_dir s = Filename.concat Config.jails_dir s

let compile_arg (x : arg) : string =
  match x with
  | Unshare_user -> "--unshare-user"
  | Unshare_user_try -> "--unshare-user-try"
  | Unshare_ipc -> "--unshare-ipc"
  | Unshare_pid -> "--unshare-pid"
  | Unshare_net -> "--unshare-net"
  | Unshare_uts -> "--unshare-uts"
  | Unshare_cgroup -> "--unshare-cgroup"
  | Unshare_cgroup_try -> "--unshare-cgroup-try"
  | Unshare_all -> "--unshare-all"
  | Uid id -> (
      match id with
      | None -> Printf.sprintf "--uid $(%s)" Commands.get_unused_uid
      | Some x -> Printf.sprintf "--uid %d" x )
  | Gid id -> (
      match id with
      | None -> Printf.sprintf "--gid $(%s)" Commands.get_unused_gid
      | Some x -> Printf.sprintf "--gid \"%d\"" x )
  | Hostname s -> Printf.sprintf "--hostname \"%s\"" s
  | Chdir s -> Printf.sprintf "--chdir \"%s\"" s
  | Setenv (key, value) -> Printf.sprintf "--setenv \"%s\" \"%s\"" key value
  | Unsetenv key -> Printf.sprintf "--unsetenv \"%s\"" key
  | Lock_file s -> Printf.sprintf "--lock-file \"%s\"" s
  | Bind (src, dst) ->
    let dst = Option.value dst ~default:src in
    Printf.sprintf "--bind \"%s\" \"%s\"" src dst
  | Bind_try (src, dst) ->
    let dst = Option.value dst ~default:src in
    Printf.sprintf "--bind-try \"%s\" \"%s\"" src dst
  | Dev_bind (src, dst) ->
    let dst = Option.value dst ~default:src in
    Printf.sprintf "--dev-bind \"%s\" \"%s\"" src dst
  | Dev_bind_try (src, dst) ->
    let dst = Option.value dst ~default:src in
    Printf.sprintf "--dev-bind-try \"%s\" \"%s\"" src dst
  | Ro_bind (src, dst) ->
    let dst = Option.value dst ~default:src in
    Printf.sprintf "--ro-bind \"%s\" \"%s\"" src dst
  | Ro_bind_try (src, dst) ->
    let dst = Option.value dst ~default:src in
    Printf.sprintf "--ro-bind-try \"%s\" \"%s\"" src dst
  | Remount_ro s -> Printf.sprintf "--remount-ro \"%s\"" s
  | Proc s -> Printf.sprintf "--proc \"%s\"" s
  | Dev s -> Printf.sprintf "--dev \"%s\"" s
  | Tmpfs s -> Printf.sprintf "--tmpfs \"%s\"" s
  | Dir s -> Printf.sprintf "--dir \"%s\"" s
  | Symlink (src, dst) ->
    let dst = Option.value dst ~default:src in
    Printf.sprintf "--symlink \"%s\" \"%s\"" src dst
  | Seccomp s -> Printf.sprintf "--seccomp 10 10<%s" s
  | New_session -> "--new-session"

let write (p : profile) : unit =
  FileUtil.mkdir ~parent:true Config.script_output_dir;
  let file_name = FilePath.concat Config.script_output_dir (p.name ^ ".sh") in
  CCIO.with_out file_name (fun oc ->
      let write_line = CCIO.write_line oc in
      write_line "#!/usr/bin/env bash";
      write_line "";
      write_line "set -euxo pipefail";
      write_line "";
      let bpf_dir =
        Printf.sprintf "\"$(dirname $0)\"/%s" Config.seccomp_bpf_output_dir
      in
      let bin_file_path =
        Printf.sprintf "\"$(dirname $0)\"/%s/%s" Config.seccomp_bpf_output_dir
          p.name
      in
      write_line
        (Printf.sprintf "gcc %s.c -lseccomp -o %s.exe" bin_file_path
           bin_file_path);
      write_line (Printf.sprintf "%s.exe" bin_file_path);
      write_line
        (Printf.sprintf "mv %s%s %s" p.name Config.seccomp_bpf_suffix bpf_dir);
      write_line "";
      ( match p.home_jail_dir with
        | None -> ()
        | Some s ->
          let jail_dir = Filename.concat Config.jails_dir s in
          let downloads_dir = Filename.concat jail_dir "Downloads" in
          write_line (Printf.sprintf "mkdir -p \"%s\"" jail_dir);
          write_line (Printf.sprintf "mkdir -p \"%s\"" downloads_dir);
          write_line "" );
      write_line "bwrap \\";
      List.iter
        (fun x -> write_line (Printf.sprintf "  %s \\" (compile_arg x)))
        ( p.args
          @
          match p.syscall_blacklist with
          | [] -> []
          | _ ->
            [
              Seccomp
                (Filename.concat bpf_dir (p.name ^ Config.seccomp_bpf_suffix));
            ] );
      write_line (Printf.sprintf "  %s" p.cmd));
  FileUtil.chmod (`Octal 0o774) [ file_name ];
  Seccomp_bpf.write_c_file ~name:p.name ~blacklist:p.syscall_blacklist
