type t = {
  name : string;
  cmd : string;
  home_jail_dir : string option;
  preserved_temp_home_dirs : string list;
  log_stdout : bool;
  log_stderr : bool;
  syscall_blacklist : Seccomp_bpf.syscall list;
  args : Bwrap.arg list;
  allow_network : bool;
  aa_caps : Aa.capability list;
  allow_wx : bool;
}
