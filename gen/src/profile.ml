type rw =
  [ `R
  | `RW
  ]

type t = {
  name : string;
  prog : string;
  args : string list;
  home_jail_dir : string option;
  preserved_temp_home_dirs : (rw * string) list;
  log_stdout : bool;
  log_stderr : bool;
  syscall_default_action : string;
  syscall_blacklist : Seccomp_bpf.syscall list;
  syscall_whitelist : Seccomp_bpf.syscall list;
  bwrap_args : Bwrap.arg list;
  allow_network : bool;
  aa_caps : Aa.capability list;
  allow_wx : bool;
  extra_aa_lines : string list;
  proc_limit : int option;
  heap_limit_MiB : int option;
}
