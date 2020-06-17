open Bw_script

let usr_share_common =
  [
    Ro_bind ("/usr/share/X11", None);
    Ro_bind ("/usr/share/icons", None);
    Ro_bind_try ("/usr/share/fontconfig", None);
    Ro_bind ("/usr/share/fonts", None);
    Ro_bind ("/usr/share/mime", None);
    Ro_bind ("/usr/share/ca-certificates", None);
    Ro_bind ("/usr/share/glib-2.0", None);
  ]

let usr_lib_lib64_bin_common =
  [
    Ro_bind ("/usr/lib", None);
    Ro_bind ("/usr/lib64", None);
    Tmpfs "/usr/lib/modules";
    Tmpfs "/usr/lib/systemd";
    Symlink ("/usr/lib", Some "/lib");
    Symlink ("/usr/lib64", Some "/lib64");
    Ro_bind ("/usr/bin", None);
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

let tmp_run_common = [ Tmpfs "/tmp"; Tmpfs "/run" ]

let sound_common =
  [
    (* Dev_bind ("/dev/snd", None); *)
    Ro_bind ("/usr/share/gst-plugins-bad", None);
    Ro_bind ("/usr/share/gst-plugins-base", None);
    Ro_bind ("/usr/share/gstreamer-1.0", None);
    Ro_bind ("/run/user/$UID/pulse", None);
  ]

let dbus_common = [ Ro_bind ("/run/user/$UID/bus", None) ]

let wayland_common = [ Ro_bind ("/run/user/$UID/wayland-0", None) ]

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
