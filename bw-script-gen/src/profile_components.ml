open Bw_script

let usr_share_common =
  [
    Ro_bind ("/usr/share/X11", None);
    Ro_bind ("/usr/share/icons", None);
    Ro_bind ("/usr/share/fonts", None);
    Ro_bind ("/usr/share/mime", None);
    Ro_bind ("/usr/share/ca-certificates", None);
  ]

let usr_lib_lib64_bin_common =
  [
    Ro_bind ("/usr/lib", None);
    Ro_bind ("/usr/lib64", None);
    Tmpfs "/usr/lib/modules";
    Tmpfs "/usr/lib/systemd";
    Symlink ("/usr/lib", Some "/lib");
    Symlink ("/usr/lib64", Some "/lib64");
    Symlink ("/usr/bin", Some "/bin");
    Symlink ("/usr/bin", Some "/sbin");
  ]

let etc_common =
  [
    Ro_bind ("/etc/fonts", None);
    Ro_bind ("/etc/machine-id", None);
    Ro_bind ("/etc/resolv.conf", None);
  ]

let proc_dev_common = [ Proc "/proc"; Dev "/dev" ]
