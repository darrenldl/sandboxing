open Bwrap
open Seccomp_bpf

let default_syscall_blacklist =
  [
    Sysctl;
    Acct;
    Add_key;
    Adjtimex;
    Afs_syscall;
    Bdflush;
    Bpf;
    Break;
    (* Chroot; *)
    Clock_adjtime;
    Clock_settime;
    Create_module;
    Delete_module;
    Fanotify_init;
    Finit_module;
    Ftime;
    Get_kernel_syms;
    Getpmsg;
    Gtty;
    Get_mempolicy;
    Init_module;
    Io_cancel;
    Io_destroy;
    Io_getevents;
    Io_setup;
    Io_submit;
    Ioperm;
    Iopl;
    Ioprio_set;
    Kcmp;
    Kexec_file_load;
    Kexec_load;
    Keyctl;
    Lock;
    Lookup_dcookie;
    Mbind;
    Migrate_pages;
    Modify_ldt;
    Mount;
    Move_pages;
    Mpx;
    Name_to_handle_at;
    Nfsservctl;
    Open_by_handle_at;
    Pciconfig_iobase;
    Pciconfig_read;
    Pciconfig_write;
    Perf_event_open;
    Personality;
    Pivot_root;
    Process_vm_readv;
    Process_vm_writev;
    Prof;
    Profil;
    Ptrace;
    Putpmsg;
    Query_module;
    Reboot;
    Remap_file_pages;
    Request_key;
    Rtas;
    S390_pci_mmio_read;
    S390_pci_mmio_write;
    S390_runtime_instr;
    Security;
    Set_mempolicy;
    Setdomainname;
    Sethostname;
    Settimeofday;
    Sgetmask;
    Ssetmask;
    Stime;
    Stty;
    Subpage_prot;
    Swapoff;
    Swapon;
    Switch_endian;
    Sysfs;
    Syslog;
    Tuxcall;
    Ulimit;
    Umount;
    Umount2;
    Uselib;
    Userfaultfd;
    Ustat;
    Vhangup;
    Vm86;
    Vm86old;
    Vmsplice;
    Vserver;
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

let usr_lib_lib64_common_rw =
  [
    Bind ("/usr/lib", None);
    Bind ("/usr/lib64", None);
    Tmpfs "/usr/lib/modules";
    Tmpfs "/usr/lib/systemd";
    Symlink ("/usr/lib", Some "/lib");
    Symlink ("/usr/lib64", Some "/lib64");
  ]

let usr_lib_lib64_common_remount_ro =
  [
    Remount_ro "/usr/lib";
    Remount_ro "/usr/lib64";
  ]

let usr_lib_lib64_bin_common =
  usr_lib_lib64_common
  @ [
    Ro_bind ("/usr/bin", None);
    Symlink ("/usr/bin", Some "/bin");
    Symlink ("/usr/bin", Some "/sbin");
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
    ( if tmp then Tmpfs Config.home_inside_jail
      else Bind (get_jail_dir name, Some Config.home_inside_jail) );
    Setenv ("HOME", Config.home_inside_jail);
  ]

let paths_of_binary (binary : string) =
  [
    Ro_bind ("/usr/bin/" ^ binary, None);
    Ro_bind ("/usr/bin/" ^ binary, Some ("/bin/" ^ binary));
    Ro_bind ("/usr/bin/" ^ binary, Some ("/sbin/" ^ binary));
  ]
