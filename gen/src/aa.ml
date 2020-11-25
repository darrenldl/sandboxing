type capability =
  | Sys_admin
  | Sys_chroot
  | Sys_ptrace

let string_of_capability c =
  match c with
  | Sys_admin -> "sys_admin"
  | Sys_chroot -> "sys_chroot"
  | Sys_ptrace -> "sys_ptrace"
