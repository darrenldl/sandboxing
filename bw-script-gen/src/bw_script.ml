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
  | Setenv of { key : string; value : string }
  | Unsetenv of string
  | Lock_file of string
  | Bind of { src : string; dst : string }
  | Bind_try of { src : string; dst : string }
  | Dev_bind of { src : string; dst : string }
  | Dev_bind_try of { src : string; dst : string }
  | Ro_bind of { src : string; dst : string }
  | Ro_bind_try of { src : string; dst : string }
  | Remount_ro of string
  | Proc of string
  | Dev of string
  | Tmpfs of string
  | Dir of string
  | Seccomp of unit

let compile_single (x : arg) : string =
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
  | Uid id ->
    (match id with
    | None -> Printf.sprintf "--uid $(%s)" Commands.get_unused_uid
    | Some x -> Printf.sprintf "--uid %d" x
    )
  | Gid id ->
    (match id with
    | None -> Printf.sprintf "--gid $(%s)" Commands.get_unused_gid
    | Some x -> Printf.sprintf "--gid %d" x
    )
  | Hostname s ->
    Printf.sprintf "--hostname '%s'" s
  | Chdir s ->
    Printf.sprintf "--chdir '%s'" s
  | Setenv { key; value } ->
    Printf.sprintf "--setenv '%s' '%s'" key value
  | Unsetenv key ->
    Printf.sprintf "--unsetenv '%s'" key
  | Lock_file s ->
    Printf.sprintf "--lock-file '%s'" s
  | Bind { src; dst } ->
    Printf.sprintf "--bind '%s' '%s'" src dst
  | Bind_try { src; dst } ->
    Printf.sprintf "--bind-try '%s' '%s'" src dst
  | Dev_bind { src; dst } ->
    Printf.sprintf "--dev-bind '%s' '%s'" src dst
  | Dev_bind_try { src; dst } ->
    Printf.sprintf "--dev-bind-try '%s' '%s'" src dst
  | Ro_bind { src; dst } ->
    Printf.sprintf "--ro-bind '%s' '%s'" src dst
  | Ro_bind_try { src; dst } ->
    Printf.sprintf "--ro-bind-try '%s' '%s'" src dst
  | Remount_ro s ->
    Printf.sprintf "--remount-ro '%s'" s
  | Proc s ->
    Printf.sprintf "--proc '%s'" s
  | Dev s ->
    Printf.sprintf "--dev '%s'" s
  | Tmpfs s ->
    Printf.sprintf "--tmpfs '%s'" s
  | Dir s ->
    Printf.sprintf "--dir '%s'" s
  | Seccomp () ->
    ""

let compile (l : arg list) : string =
  String.concat "\n"
    (
      "bwrap \\" ::
      List.map (fun s ->
          Printf.sprintf "  %s \\"
            (compile_single s)
        ) l
    )
