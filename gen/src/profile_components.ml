open Bwrap
open Seccomp_bpf

(* Based on https://github.com/valoq/bwscripts *)
let default_syscall_blacklist : syscall list =
  [
    { name = "_sysctl"; args = [] };
    { name = "acct"; args = [] };
    { name = "add_key"; args = [] };
    { name = "adjtimex"; args = [] };
    { name = "afs_syscall"; args = [] };
    { name = "bdflush"; args = [] };
    { name = "bpf"; args = [] };
    { name = "break"; args = [] };
    { name = "clock_adjtime"; args = [] };
    { name = "clock_settime"; args = [] };
    { name = "create_module"; args = [] };
    { name = "delete_module"; args = [] };
    { name = "fanotify_init"; args = [] };
    { name = "finit_module"; args = [] };
    { name = "ftime"; args = [] };
    { name = "get_kernel_syms"; args = [] };
    { name = "getpmsg"; args = [] };
    { name = "gtty"; args = [] };
    { name = "get_mempolicy"; args = [] };
    { name = "init_module"; args = [] };
    { name = "io_cancel"; args = [] };
    { name = "io_destroy"; args = [] };
    { name = "io_getevents"; args = [] };
    { name = "io_setup"; args = [] };
    { name = "io_submit"; args = [] };
    { name = "ioperm"; args = [] };
    { name = "iopl"; args = [] };
    { name = "ioprio_set"; args = [] };
    { name = "kcmp"; args = [] };
    { name = "kexec_file_load"; args = [] };
    { name = "kexec_load"; args = [] };
    { name = "keyctl"; args = [] };
    { name = "lock"; args = [] };
    { name = "lookup_dcookie"; args = [] };
    { name = "mbind"; args = [] };
    { name = "migrate_pages"; args = [] };
    { name = "modify_ldt"; args = [] };
    { name = "mount"; args = [] };
    { name = "move_pages"; args = [] };
    { name = "mpx"; args = [] };
    { name = "name_to_handle_at"; args = [] };
    { name = "nfsservctl"; args = [] };
    { name = "open_by_handle_at"; args = [] };
    { name = "pciconfig_iobase"; args = [] };
    { name = "pciconfig_read"; args = [] };
    { name = "pciconfig_write"; args = [] };
    { name = "perf_event_open"; args = [] };
    { name = "personality"; args = [] };
    { name = "pivot_root"; args = [] };
    { name = "process_vm_readv"; args = [] };
    { name = "process_vm_writev"; args = [] };
    { name = "prof"; args = [] };
    { name = "profil"; args = [] };
    { name = "ptrace"; args = [] };
    { name = "putpmsg"; args = [] };
    { name = "query_module"; args = [] };
    { name = "reboot"; args = [] };
    { name = "remap_file_pages"; args = [] };
    { name = "request_key"; args = [] };
    { name = "rtas"; args = [] };
    { name = "s390_pci_mmio_read"; args = [] };
    { name = "s390_runtime_instr"; args = [] };
    { name = "security"; args = [] };
    { name = "set_mempolicy"; args = [] };
    { name = "setdomainname"; args = [] };
    { name = "sethostname"; args = [] };
    { name = "settimeofday"; args = [] };
    { name = "sgetmask"; args = [] };
    { name = "ssetmask"; args = [] };
    { name = "stime"; args = [] };
    { name = "stty"; args = [] };
    { name = "subpage_prot"; args = [] };
    { name = "swapoff"; args = [] };
    { name = "swapon"; args = [] };
    { name = "switch_endian"; args = [] };
    { name = "sysfs"; args = [] };
    { name = "syslog"; args = [] };
    { name = "tuxcall"; args = [] };
    { name = "ulimit"; args = [] };
    { name = "umount"; args = [] };
    { name = "umount2"; args = [] };
    { name = "uselib"; args = [] };
    { name = "userfaultfd"; args = [] };
    { name = "ustat"; args = [] };
    { name = "vhangup"; args = [] };
    { name = "vm86"; args = [] };
    { name = "vm86old"; args = [] };
    { name = "vmsplice"; args = [] };
    { name = "vserver"; args = [] };
    { name = "ioctl"; args = [ (1, "TIOCSTI") ] };
  ]

(* Based on https://github.com/Whonix/sandbox-app-launcher *)
let default_syscall_whitelist : syscall list =
  [
    { name = "_llseek"; args = [] };
    { name = "_newselect"; args = [] };
    { name = "accept"; args = [] };
    { name = "accept4"; args = [] };
    { name = "access"; args = [] };
    { name = "alarm"; args = [] };
    { name = "arch_prctl"; args = [] };
    { name = "bind"; args = [] };
    { name = "brk"; args = [] };
    { name = "cacheflush"; args = [] };
    { name = "capget"; args = [] };
    { name = "capset"; args = [] };
    { name = "chdir"; args = [] };
    { name = "chmod"; args = [] };
    { name = "chown"; args = [] };
    { name = "chown32"; args = [] };
    { name = "chroot"; args = [] };
    { name = "clock_getres"; args = [] };
    { name = "clock_gettime"; args = [] };
    { name = "clock_nanosleep"; args = [] };
    { name = "clone"; args = [] };
    { name = "close"; args = [] };
    { name = "connect"; args = [] };
    { name = "copy_file_range"; args = [] };
    { name = "creat"; args = [] };
    { name = "dup"; args = [] };
    { name = "dup2"; args = [] };
    { name = "dup3"; args = [] };
    { name = "epoll_create"; args = [] };
    { name = "epoll_create1"; args = [] };
    { name = "epoll_ctl"; args = [] };
    { name = "epoll_pwait"; args = [] };
    { name = "epoll_wait"; args = [] };
    { name = "eventfd"; args = [] };
    { name = "eventfd2"; args = [] };
    { name = "execve"; args = [] };
    { name = "execveat"; args = [] };
    { name = "exit"; args = [] };
    { name = "exit_group"; args = [] };
    { name = "faccessat"; args = [] };
    { name = "fadvise64"; args = [] };
    { name = "fadvise64_64"; args = [] };
    { name = "fallocate"; args = [] };
    { name = "fanotify_mark"; args = [] };
    { name = "fchdir"; args = [] };
    { name = "fchmod"; args = [] };
    { name = "fchmodat"; args = [] };
    { name = "fchown"; args = [] };
    { name = "fchown32"; args = [] };
    { name = "fchownat"; args = [] };
    { name = "fcntl"; args = [] };
    { name = "fcntl64"; args = [] };
    { name = "fdatasync"; args = [] };
    { name = "fgetxattr"; args = [] };
    { name = "flistxattr"; args = [] };
    { name = "flock"; args = [] };
    { name = "fork"; args = [] };
    { name = "fremovexattr"; args = [] };
    { name = "fstat"; args = [] };
    { name = "fstat64"; args = [] };
    { name = "fstatat64"; args = [] };
    { name = "fstatfs"; args = [] };
    { name = "fstatfs64"; args = [] };
    { name = "fsync"; args = [] };
    { name = "ftruncate"; args = [] };
    { name = "ftruncate64"; args = [] };
    { name = "futex"; args = [] };
    { name = "futimesat"; args = [] };
    { name = "get_robust_list"; args = [] };
    { name = "get_thread_area"; args = [] };
    { name = "getcpu"; args = [] };
    { name = "getcwd"; args = [] };
    { name = "getdents"; args = [] };
    { name = "getdents64"; args = [] };
    { name = "getegid"; args = [] };
    { name = "getegid32"; args = [] };
    { name = "geteuid"; args = [] };
    { name = "geteuid32"; args = [] };
    { name = "getgid"; args = [] };
    { name = "getgid32"; args = [] };
    { name = "getgroups"; args = [] };
    { name = "getgroups32"; args = [] };
    { name = "getitimer"; args = [] };
    { name = "getpeername"; args = [] };
    { name = "getpgid"; args = [] };
    { name = "getpgrp"; args = [] };
    { name = "getpid"; args = [] };
    { name = "getppid"; args = [] };
    { name = "getpriority"; args = [] };
    { name = "getrandom"; args = [] };
    { name = "getresgid"; args = [] };
    { name = "getresgid32"; args = [] };
    { name = "getresuid"; args = [] };
    { name = "getresuid32"; args = [] };
    { name = "getrlimit"; args = [] };
    { name = "getrusage"; args = [] };
    { name = "getsid"; args = [] };
    { name = "getsockname"; args = [] };
    { name = "getsockopt"; args = [] };
    { name = "gettid"; args = [] };
    { name = "gettimeofday"; args = [] };
    { name = "getuid"; args = [] };
    { name = "getuid32"; args = [] };
    { name = "getxattr"; args = [] };
    { name = "inotify_add_watch"; args = [] };
    { name = "inotify_init"; args = [] };
    { name = "inotify_init1"; args = [] };
    { name = "inotify_rm_watch"; args = [] };
    { name = "ioctl"; args = [ (1, "FIOCLEX") ] };
    { name = "ioctl"; args = [ (1, "FIONBIO") ] };
    { name = "ioctl"; args = [ (1, "FIONREAD") ] };
    { name = "ioctl"; args = [ (1, "RNDGETENTCNT") ] };
    { name = "ioctl"; args = [ (1, "TCGETS") ] };
    { name = "ioctl"; args = [ (1, "TCSETS") ] };
    { name = "ioctl"; args = [ (1, "TCSETSW") ] };
    { name = "ioctl"; args = [ (1, "TIOCGPGRP") ] };
    { name = "ioctl"; args = [ (1, "TIOCGWINSZ") ] };
    { name = "ioctl"; args = [ (1, "TIOCSPGRP") ] };
    { name = "ioctl"; args = [ (1, "TIOCSWINSZ") ] };
    { name = "ioctl"; args = [ (1, "VT_GETSTATE") ] };
    { name = "ioprio_get"; args = [] };
    { name = "ipc"; args = [] };
    { name = "kill"; args = [] };
    { name = "lchown"; args = [] };
    { name = "lchown32"; args = [] };
    { name = "lgetxattr"; args = [] };
    { name = "link"; args = [] };
    { name = "linkat"; args = [] };
    { name = "listen"; args = [] };
    { name = "listxattr"; args = [] };
    { name = "llistxattr"; args = [] };
    { name = "lremovexattr"; args = [] };
    { name = "lseek"; args = [] };
    { name = "lsetxattr"; args = [] };
    { name = "lstat"; args = [] };
    { name = "lstat64"; args = [] };
    { name = "madvise"; args = [] };
    { name = "membarrier"; args = [] };
    { name = "memfd_create"; args = [] };
    { name = "mincore"; args = [] };
    { name = "mkdir"; args = [] };
    { name = "mkdirat"; args = [] };
    (* We don't need to allow creation of char/block devices *)
    { name = "mknod"; args = [ (1, "S_IFREG") ] };
    { name = "mknod"; args = [ (1, "S_IFIFO") ] };
    { name = "mknod"; args = [ (1, "S_IFSOCK") ] };
    { name = "mknodat"; args = [ (1, "S_IFREG") ] };
    { name = "mknodat"; args = [ (1, "S_IFIFO") ] };
    { name = "mknodat"; args = [ (1, "S_IFSOCK") ] };
    (* --- *)
    { name = "mlock"; args = [] };
    { name = "mlock2"; args = [] };
    { name = "mlockall"; args = [] };
    { name = "mq_getsetattr"; args = [] };
    { name = "mq_notify"; args = [] };
    { name = "mq_open"; args = [] };
    { name = "mq_timedreceive"; args = [] };
    { name = "mq_timedsend"; args = [] };
    { name = "mq_unlink"; args = [] };
    { name = "mremap"; args = [] };
    { name = "msgctl"; args = [] };
    { name = "msgget"; args = [] };
    { name = "msgrcv"; args = [] };
    { name = "msgsnd"; args = [] };
    { name = "msync"; args = [] };
    { name = "munlock"; args = [] };
    { name = "munlockall"; args = [] };
    { name = "munmap"; args = [] };
    { name = "nanosleep"; args = [] };
    { name = "newfstatat"; args = [] };
    { name = "nice"; args = [] };
    { name = "oldfstat"; args = [] };
    { name = "oldlstat"; args = [] };
    { name = "oldolduname"; args = [] };
    { name = "oldstat"; args = [] };
    { name = "olduname"; args = [] };
    { name = "open"; args = [] };
    { name = "openat"; args = [] };
    { name = "pause"; args = [] };
    { name = "pipe"; args = [] };
    { name = "pipe2"; args = [] };
    { name = "pkey_alloc"; args = [] };
    { name = "pkey_free"; args = [] };
    { name = "poll"; args = [] };
    { name = "ppoll"; args = [] };
    { name = "prctl"; args = [] };
    { name = "pread64"; args = [] };
    { name = "preadv"; args = [] };
    { name = "preadv2"; args = [] };
    { name = "prlimit64"; args = [] };
    { name = "pselect6"; args = [] };
    { name = "pwrite64"; args = [] };
    { name = "pwritev"; args = [] };
    { name = "pwritev2"; args = [] };
    { name = "quotactl"; args = [] };
    { name = "read"; args = [] };
    { name = "readahead"; args = [] };
    { name = "readdir"; args = [] };
    { name = "readlink"; args = [] };
    { name = "readlinkat"; args = [] };
    { name = "readv"; args = [] };
    { name = "recv"; args = [] };
    { name = "recvfrom"; args = [] };
    { name = "recvmsg"; args = [] };
    { name = "recvmmsg"; args = [] };
    { name = "removexattr"; args = [] };
    { name = "rename"; args = [] };
    { name = "renameat"; args = [] };
    { name = "renameat2"; args = [] };
    { name = "restart_syscall"; args = [] };
    { name = "rmdir"; args = [] };
    { name = "rt_sigaction"; args = [] };
    { name = "rt_sigpending"; args = [] };
    { name = "rt_sigprocmask"; args = [] };
    { name = "rt_sigqueueinfo"; args = [] };
    { name = "rt_sigreturn"; args = [] };
    { name = "rt_sigsuspend"; args = [] };
    { name = "rt_sigtimedwait"; args = [] };
    { name = "rt_tgsigqueueinfo"; args = [] };
    { name = "s390_pci_mmio_read"; args = [] };
    { name = "s390_pci_mmio_write"; args = [] };
    { name = "s390_sthyi"; args = [] };
    { name = "sched_get_priority_max"; args = [] };
    { name = "sched_get_priority_min"; args = [] };
    { name = "sched_getaffinity"; args = [] };
    { name = "sched_getattr"; args = [] };
    { name = "sched_getparam"; args = [] };
    { name = "sched_getscheduler"; args = [] };
    { name = "sched_rr_get_interval"; args = [] };
    { name = "sched_setaffinity"; args = [] };
    { name = "sched_setattr"; args = [] };
    { name = "sched_setparam"; args = [] };
    { name = "sched_setscheduler"; args = [] };
    { name = "sched_yield"; args = [] };
    { name = "seccomp"; args = [] };
    { name = "select"; args = [] };
    { name = "semctl"; args = [] };
    { name = "semget"; args = [] };
    { name = "semop"; args = [] };
    { name = "semtimedop"; args = [] };
    { name = "send"; args = [] };
    { name = "sendfile"; args = [] };
    { name = "sendfile64"; args = [] };
    { name = "sendmmsg"; args = [] };
    { name = "sendmsg"; args = [] };
    { name = "sendto"; args = [] };
    { name = "set_robust_list"; args = [] };
    { name = "set_thread_area"; args = [] };
    { name = "set_tid_address"; args = [] };
    { name = "setfsgid"; args = [] };
    { name = "setfsgid32"; args = [] };
    { name = "setfsuid"; args = [] };
    { name = "setfsuid32"; args = [] };
    { name = "setgid"; args = [] };
    { name = "setgid32"; args = [] };
    { name = "setgroups"; args = [] };
    { name = "setgroups32"; args = [] };
    { name = "setitimer"; args = [] };
    { name = "setns"; args = [] };
    { name = "setpgid"; args = [] };
    { name = "setpriority"; args = [] };
    { name = "setregid"; args = [] };
    { name = "setregid32"; args = [] };
    { name = "setresgid"; args = [] };
    { name = "setresgid32"; args = [] };
    { name = "setresuid"; args = [] };
    { name = "setresuid32"; args = [] };
    { name = "setrlimit"; args = [] };
    { name = "setsid"; args = [] };
    { name = "setsockopt"; args = [] };
    { name = "setuid"; args = [] };
    { name = "setuid32"; args = [] };
    { name = "setxattr"; args = [] };
    { name = "shmctl"; args = [] };
    { name = "shmdt"; args = [] };
    { name = "shmget"; args = [] };
    { name = "shutdown"; args = [] };
    { name = "sigaction"; args = [] };
    { name = "sigaltstack"; args = [] };
    { name = "signal"; args = [] };
    { name = "signalfd"; args = [] };
    { name = "signalfd4"; args = [] };
    { name = "sigpending"; args = [] };
    { name = "sigprocmask"; args = [] };
    { name = "sigreturn"; args = [] };
    { name = "sigsuspend"; args = [] };
    { name = "socket"; args = [ (0, "AF_INET") ] };
    { name = "socket"; args = [ (0, "AF_INET6") ] };
    { name = "socket"; args = [ (0, "AF_LOCAL") ] };
    { name = "socket"; args = [ (0, "AF_NETLINK") ] };
    { name = "socket"; args = [ (0, "AF_UNIX") ] };
    { name = "socket"; args = [ (0, "AF_UNSPEC") ] };
    { name = "socketcall"; args = [] };
    { name = "socketpair"; args = [] };
    { name = "splice"; args = [] };
    { name = "spu_create"; args = [] };
    { name = "spu_run"; args = [] };
    { name = "stat"; args = [] };
    { name = "stat64"; args = [] };
    { name = "statfs"; args = [] };
    { name = "statfs64"; args = [] };
    { name = "statx"; args = [] };
    { name = "symlink"; args = [] };
    { name = "symlinkat"; args = [] };
    { name = "sync"; args = [] };
    { name = "sync_file_range"; args = [] };
    { name = "sync_file_range2"; args = [] };
    { name = "syncfs"; args = [] };
    { name = "sysinfo"; args = [] };
    { name = "tee"; args = [] };
    { name = "tgkill"; args = [] };
    { name = "time"; args = [] };
    { name = "timer_create"; args = [] };
    { name = "timer_delete"; args = [] };
    { name = "timer_getoverrun"; args = [] };
    { name = "timer_gettime"; args = [] };
    { name = "timer_settime"; args = [] };
    { name = "timerfd_create"; args = [] };
    { name = "timerfd_gettime"; args = [] };
    { name = "timerfd_settime"; args = [] };
    { name = "times"; args = [] };
    { name = "tkill"; args = [] };
    { name = "truncate"; args = [] };
    { name = "truncate64"; args = [] };
    { name = "ugetrlimit"; args = [] };
    { name = "umask"; args = [] };
    { name = "uname"; args = [] };
    { name = "unlink"; args = [] };
    { name = "unlinkat"; args = [] };
    { name = "unshare"; args = [] };
    { name = "utime"; args = [] };
    { name = "utimensat"; args = [] };
    { name = "utimes"; args = [] };
    { name = "vfork"; args = [] };
    { name = "wait4"; args = [] };
    { name = "waitid"; args = [] };
    { name = "waitpid"; args = [] };
    { name = "write"; args = [] };
    { name = "writev"; args = [] };
    (* W^X *)
    (* Disallow creating writable and executable mappings *)
    { name = "mmap"; args = [ (2, "PROT_NONE") ] };
    { name = "mmap"; args = [ (2, "PROT_READ") ] };
    { name = "mmap"; args = [ (2, "PROT_WRITE") ] };
    { name = "mmap"; args = [ (2, "PROT_EXEC") ] };
    { name = "mmap"; args = [ (2, "PROT_READ|PROT_EXEC") ] };
    { name = "mmap"; args = [ (2, "PROT_READ|PROT_WRITE") ] };
    { name = "mmap2"; args = [ (2, "PROT_NONE") ] };
    { name = "mmap2"; args = [ (2, "PROT_READ") ] };
    { name = "mmap2"; args = [ (2, "PROT_WRITE") ] };
    { name = "mmap2"; args = [ (2, "PROT_EXEC") ] };
    { name = "mmap2"; args = [ (2, "PROT_READ|PROT_EXEC") ] };
    { name = "mmap2"; args = [ (2, "PROT_READ|PROT_WRITE") ] };
    (* Disallow transitioning mappings to executable *)
    { name = "mprotect"; args = [ (2, "PROT_NONE") ] };
    { name = "mprotect"; args = [ (2, "PROT_READ") ] };
    { name = "mprotect"; args = [ (2, "PROT_WRITE") ] };
    { name = "mprotect"; args = [ (2, "PROT_READ|PROT_WRITE") ] };
    { name = "pkey_mprotect"; args = [ (2, "PROT_NONE") ] };
    { name = "pkey_mprotect"; args = [ (2, "PROT_READ") ] };
    { name = "pkey_mprotect"; args = [ (2, "PROT_WRITE") ] };
    { name = "pkey_mprotect"; args = [ (2, "PROT_READ|PROT_WRITE") ] };
    (* Disallow mapping shared memory segments as executable *)
    { name = "shmat"; args = [ (2, "0") ] };
    { name = "shmat"; args = [ (2, "SHM_RND") ] };
    { name = "shmat"; args = [ (2, "SHM_RDONLY") ] };
    { name = "shmat"; args = [ (2, "SHM_REMAP") ] };
  ]

let default_syscall_whitelist_wx : syscall list =
  default_syscall_whitelist
  @ [
      { name = "mmap"; args = [] };
      { name = "mmap2"; args = [] };
      { name = "mprotect"; args = [] };
      { name = "pkey_mprotect"; args = [] };
      { name = "shmat"; args = [] };
    ]

let usr_share_common = [ Ro_bind ("/usr/share", None) ]

(* [
     Ro_bind ("/usr/share/X11", None);
     Ro_bind ("/usr/share/icons", None);
     Ro_bind_try ("/usr/share/fontconfig", None);
     Ro_bind ("/usr/share/fonts", None);
     Ro_bind ("/usr/share/mime", None);
     Ro_bind ("/usr/share/ca-certificates", None);
     Ro_bind ("/usr/share/glib-2.0", None);
   ] *)

let usr_lib_lib64_common =
  [
    Ro_bind ("/usr/lib", None);
    Ro_bind ("/usr/lib64", None);
    Tmpfs "/usr/lib/modules";
    Tmpfs "/usr/lib/systemd";
    Symlink ("/usr/lib", Some "/lib");
    Symlink ("/usr/lib64", Some "/lib64");
  ]

let disallow_browsers = [ Tmpfs "/usr/lib/firefox" ]

let usr_lib_lib64_bin_common =
  usr_lib_lib64_common
  @ [
      Ro_bind ("/usr/bin", None);
      Symlink ("/usr/bin", Some "/bin");
      Symlink ("/usr/bin", Some "/sbin");
      Setenv ("PATH", "/usr/bin");
    ]

let etc_common =
  [ Ro_bind ("/etc/fonts", None); Ro_bind ("/etc/resolv.conf", None) ]

let etc_ssl =
  [ Ro_bind ("/etc/ssl", None); Ro_bind ("/etc/ca-certificates", None) ]

let etc_localtime = [ Ro_bind ("/etc/localtime", None) ]

let proc_dev_common = [ Proc "/proc"; Dev "/dev" ]

let tmp_run_common = [ Tmpfs "/tmp"; Tmpfs "/run" ]

let sound_common =
  [
    (* Dev_bind ("/dev/snd", None); *)
    Ro_bind_try ("/usr/share/gst-plugins-bad", None);
    Ro_bind_try ("/usr/share/gst-plugins-base", None);
    Ro_bind_try ("/usr/share/gstreamer-1.0", None);
    Ro_bind ("/run/user/$UID/pulse", None);
  ]

let dbus_common = [ Ro_bind ("/run/user/$UID/bus", None) ]

let wayland_common =
  [
    Ro_bind_try ("/run/user/$UID/wayland-0", None);
    Ro_bind_try ("/run/user/$UID/wayland-1", None);
    Ro_bind_try ("/run/user/$UID/wayland-2", None);
    Ro_bind_try ("/run/user/$UID/wayland-3", None);
    Setenv ("QT_QPA_PLATFORM", "wayland");
  ]

let x11_common = [ Ro_bind ("/tmp/.X11-unix", None) ]

let dconf_common = [ Bind ("/run/user/$UID/dconf", None) ]

let lsb_release_common =
  [ Ro_bind ("/etc/lsb-release", None); Ro_bind ("/etc/arch-release", None) ]

let set_up_jail_home ~tmp ~name =
  [
    (if tmp then Tmpfs Config.home_inside_jail
    else Bind (get_jail_dir name, Some Config.home_inside_jail));
    Setenv ("HOME", Config.home_inside_jail);
  ]

let paths_of_binary (binary : string) =
  [
    Ro_bind ("/usr/bin/" ^ binary, None);
    Ro_bind ("/usr/bin/" ^ binary, Some ("/bin/" ^ binary));
    Ro_bind ("/usr/bin/" ^ binary, Some ("/sbin/" ^ binary));
  ]
