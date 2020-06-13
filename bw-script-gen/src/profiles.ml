open Bw_script

let get_jail_dir s = Filename.concat Config.jail_dir s

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
        Uid None;
        Gid None;
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
        Tmpfs "/tmp";
        Tmpfs "/run";
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
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_cgroup;
        New_session;
      ];
  }

let suite = [ bash; firefox ]
