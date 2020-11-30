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
  | File (fd, dst) -> Printf.sprintf "--file %d \"%s\"" fd dst
  | Bind_data (fd, dst) -> Printf.sprintf "--file %d \"%s\"" fd dst
  | Ro_bind_data (fd, dst) -> Printf.sprintf "--file %d \"%s\"" fd dst
  | Symlink (src, dst) ->
    let dst = Option.value dst ~default:src in
    Printf.sprintf "--symlink \"%s\" \"%s\"" src dst
  | Seccomp s -> Printf.sprintf "--seccomp 10 10<%s" s
  | New_session -> "--new-session"
