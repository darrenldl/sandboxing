open Bw_script

let bash : profile =
  {
    name = "bash";
    cmd = "bash";
    home_jail_dir = Some "bash";
    args =
      [
        Ro_bind ("/", None);
        Ro_bind ("/usr/bin", None);
        Tmpfs "/usr/lib/modules";
        Tmpfs "/usr/lib/systemd";
        Proc "/proc";
        Dev "/dev";
        Tmpfs "/run";
        Unshare_user;
        (* Uid None;
         * Gid None; *)
        Tmpfs "/home";
        Bind (get_jail_dir "bash", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
      ];
  }

let firefox : profile =
  {
    name = "firefox";
    cmd = "/usr/lib/firefox/firefox --ProfileManager";
    home_jail_dir = Some "firefox";
    args =
      [
        Ro_bind ("/usr/bin", None);
        Ro_bind ("/usr/share", None);
        Ro_bind ("/usr/lib", None);
        Ro_bind ("/usr/lib64", None);
        Symlink ("/usr/lib", Some "/lib");
        Symlink ("/usr/lib64", Some "/lib64");
        Symlink ("/usr/bin", Some "/bin");
        Symlink ("/usr/bin", Some "/sbin");
        Ro_bind ("/etc", None);
        Tmpfs "/usr/lib/modules";
        Tmpfs "/usr/lib/systemd";
        Proc "/proc";
        Dev "/dev";
        Dev_bind ("/dev/snd", None);
        Tmpfs "/tmp";
        Tmpfs "/run";
        Tmpfs "/opt";
        Ro_bind ("/run/user/1000/bus", None);
        Ro_bind ("/run/user/1000/pulse", None);
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
        Tmpfs "/home";
        Bind (get_jail_dir "firefox", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
        Bind ("~/.mozilla", Some "/home/jail/.mozilla");
        Bind ("~/.cache/mozilla", Some "/home/jail/.cache/mozilla");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Setenv ("MOZ_ENABLE_WAYLAND", "1");
        Hostname "JAIL";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_cgroup;
        New_session;
      ];
  }

let firefox_private : profile =
  {
    name = "firefox-private";
    cmd = "/usr/lib/firefox/firefox";
    home_jail_dir = Some "firefox";
    args =
      [
        Ro_bind ("/usr/bin", None);
        Ro_bind ("/usr/share", None);
        Ro_bind ("/usr/lib", None);
        Ro_bind ("/usr/lib64", None);
        Symlink ("/usr/lib", Some "/lib");
        Symlink ("/usr/lib64", Some "/lib64");
        Symlink ("/usr/bin", Some "/bin");
        Symlink ("/usr/bin", Some "/sbin");
        Ro_bind ("/etc", None);
        Tmpfs "/usr/lib/modules";
        Tmpfs "/usr/lib/systemd";
        Proc "/proc";
        Dev "/dev";
        Dev_bind ("/dev/snd", None);
        Tmpfs "/tmp";
        Tmpfs "/run";
        Tmpfs "/opt";
        Ro_bind ("/run/user/1000/bus", None);
        Ro_bind ("/run/user/1000/pulse", None);
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
        Tmpfs "/home";
        Bind (get_jail_dir "firefox", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Setenv ("MOZ_ENABLE_WAYLAND", "1");
        Hostname "JAIL";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_cgroup;
        New_session;
      ];
  }

let discord : profile =
  {
    name = "discord";
    cmd = "/opt/discord/Discord";
    home_jail_dir = Some "discord";
    args =
      [
        Ro_bind ("/usr/bin", None);
        Ro_bind ("/usr/share", None);
        Ro_bind ("/usr/lib", None);
        Ro_bind ("/usr/lib64", None);
        Symlink ("/usr/lib", Some "/lib");
        Symlink ("/usr/lib64", Some "/lib64");
        Symlink ("/usr/bin", Some "/bin");
        Symlink ("/usr/bin", Some "/sbin");
        Ro_bind ("/etc", None);
        Tmpfs "/usr/lib/modules";
        Tmpfs "/usr/lib/systemd";
        Proc "/proc";
        Dev "/dev";
        Dev_bind ("/dev/snd", None);
        Tmpfs "/tmp";
        Tmpfs "/run";
        Ro_bind ("/run/user/1000/bus", None);
        Ro_bind ("/run/user/1000/pulse", None);
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
        Tmpfs "/opt";
        Ro_bind ("/opt/discord", None);
        Tmpfs "/home";
        Bind (get_jail_dir "discord", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Hostname "JAIL";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_cgroup;
        New_session;
      ];
  }

let thunderbird : profile =
  {
    name = "thunderbird";
    cmd = "/usr/lib/thunderbird/thunderbird";
    home_jail_dir = Some "thunderbird";
    args =
      [
        Ro_bind ("/usr/bin", None);
        Ro_bind ("/usr/share", None);
        Ro_bind ("/usr/lib", None);
        Ro_bind ("/usr/lib64", None);
        Symlink ("/usr/lib", Some "/lib");
        Symlink ("/usr/lib64", Some "/lib64");
        Symlink ("/usr/bin", Some "/bin");
        Symlink ("/usr/bin", Some "/sbin");
        Ro_bind ("/etc", None);
        Tmpfs "/usr/lib/modules";
        Tmpfs "/usr/lib/systemd";
        Proc "/proc";
        Dev "/dev";
        Tmpfs "/tmp";
        Tmpfs "/run";
        Tmpfs "/opt";
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
        Tmpfs "/home";
        Bind (get_jail_dir "discord", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Hostname "JAIL";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_cgroup;
        New_session;
      ];
  }

let suite = [ bash; firefox; firefox_private; discord; thunderbird ]
