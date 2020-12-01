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
  | File of int * string
  | Bind_data of int * string
  | Ro_bind_data of int * string
  | Symlink of string * string option
  | Seccomp of string
  | New_session
  | Ro_bind_as_is_glob of string
  | Tmpfs_glob of string

type res =
  | String of string
  | Glob of {
      arg_constr : string -> string;
      glob : string;
    }

let get_jail_dir s = Filename.concat Config.jails_dir s

let compile_arg (x : arg) : res =
  match x with
  | Unshare_user -> String "--unshare-user"
  | Unshare_user_try -> String "--unshare-user-try"
  | Unshare_ipc -> String "--unshare-ipc"
  | Unshare_pid -> String "--unshare-pid"
  | Unshare_net -> String "--unshare-net"
  | Unshare_uts -> String "--unshare-uts"
  | Unshare_cgroup -> String "--unshare-cgroup"
  | Unshare_cgroup_try -> String "--unshare-cgroup-try"
  | Unshare_all -> String "--unshare-all"
  | Uid id -> (
      match id with
      | None -> String (Printf.sprintf "--uid $(%s)" Commands.get_unused_uid)
      | Some x -> String (Printf.sprintf "--uid %d" x) )
  | Gid id -> (
      match id with
      | None -> String (Printf.sprintf "--gid $(%s)" Commands.get_unused_gid)
      | Some x -> String (Printf.sprintf "--gid \"%d\"" x) )
  | Hostname s -> String (Printf.sprintf "--hostname \"%s\"" s)
  | Chdir s -> String (Printf.sprintf "--chdir \"%s\"" s)
  | Setenv (key, value) ->
    String (Printf.sprintf "--setenv \"%s\" \"%s\"" key value)
  | Unsetenv key -> String (Printf.sprintf "--unsetenv \"%s\"" key)
  | Lock_file s -> String (Printf.sprintf "--lock-file \"%s\"" s)
  | Bind (src, dst) ->
    let dst = Option.value dst ~default:src in
    String (Printf.sprintf "--bind \"%s\" \"%s\"" src dst)
  | Bind_try (src, dst) ->
    let dst = Option.value dst ~default:src in
    String (Printf.sprintf "--bind-try \"%s\" \"%s\"" src dst)
  | Dev_bind (src, dst) ->
    let dst = Option.value dst ~default:src in
    String (Printf.sprintf "--dev-bind \"%s\" \"%s\"" src dst)
  | Dev_bind_try (src, dst) ->
    let dst = Option.value dst ~default:src in
    String (Printf.sprintf "--dev-bind-try \"%s\" \"%s\"" src dst)
  | Ro_bind (src, dst) ->
    let dst = Option.value dst ~default:src in
    String (Printf.sprintf "--ro-bind \"%s\" \"%s\"" src dst)
  | Ro_bind_try (src, dst) ->
    let dst = Option.value dst ~default:src in
    String (Printf.sprintf "--ro-bind-try \"%s\" \"%s\"" src dst)
  | Remount_ro s -> String (Printf.sprintf "--remount-ro \"%s\"" s)
  | Proc s -> String (Printf.sprintf "--proc \"%s\"" s)
  | Dev s -> String (Printf.sprintf "--dev \"%s\"" s)
  | Tmpfs s -> String (Printf.sprintf "--tmpfs \"%s\"" s)
  | Dir s -> String (Printf.sprintf "--dir \"%s\"" s)
  | File (fd, dst) -> String (Printf.sprintf "--file %d \"%s\"" fd dst)
  | Bind_data (fd, dst) -> String (Printf.sprintf "--file %d \"%s\"" fd dst)
  | Ro_bind_data (fd, dst) -> String (Printf.sprintf "--file %d \"%s\"" fd dst)
  | Symlink (src, dst) ->
    let dst = Option.value dst ~default:src in
    String (Printf.sprintf "--symlink \"%s\" \"%s\"" src dst)
  | Seccomp s -> String (Printf.sprintf "--seccomp 10 10<%s" s)
  | New_session -> String "--new-session"
  | Ro_bind_as_is_glob glob ->
    Glob
      {
        arg_constr = (fun x -> Printf.sprintf "--ro-bind \"%s\" \"%s\"" x x);
        glob;
      }
  | Tmpfs_glob glob ->
    Glob { arg_constr = (fun x -> Printf.sprintf "--tmpfs \"%s\"" x); glob }
