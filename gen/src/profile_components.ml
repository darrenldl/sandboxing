open Bwrap
open Seccomp_bpf

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
    { name = "ioctl"; args = [(1, "TIOCSTI")] };
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

let etc_ssl = [ Ro_bind ("/etc/ssl", None) ]

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
    Ro_bind ("/run/user/$UID/wayland-0", None);
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
