open Bw_script
open Profile_components

let bash : profile =
  {
    name = "bash";
    cmd = "bash";
    home_jail_dir = Some "bash";
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ [
        Ro_bind ("/usr/bin", None);
        Unshare_user;
        Unshare_ipc;
        (* Uid None;
         * Gid None; *)
        Tmpfs "/home";
        Bind (get_jail_dir "bash", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
      ];
  }

let make_firefox_profile ~(suffix : string option) : profile =
  let name = match suffix with None -> "firefox" | Some s -> "firefox-" ^ s in
  {
    name;
    cmd = "/usr/lib/firefox/firefox --ProfileManager";
    home_jail_dir = Some name;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ [
        Dev_bind ("/dev/snd", None);
        Ro_bind ("/run/user/1000/bus", None);
        Ro_bind ("/run/user/1000/pulse", None);
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
        Tmpfs "/home";
        Bind (get_jail_dir name, Some "/home/jail");
        Setenv ("HOME", "/home/jail");
        Bind ("$HOME/.mozilla", Some "/home/jail/.mozilla");
        Bind ("$HOME/.cache/mozilla", Some "/home/jail/.cache/mozilla");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Setenv ("MOZ_ENABLE_WAYLAND", "1");
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        New_session;
      ];
  }

let firefox_private : profile =
  {
    name = "firefox-private";
    cmd = "/usr/lib/firefox/firefox";
    home_jail_dir = None;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ [
        Dev_bind ("/dev/snd", None);
        Tmpfs "/tmp";
        Tmpfs "/run";
        Tmpfs "/opt";
        Ro_bind ("/run/user/1000/bus", None);
        Ro_bind ("/run/user/1000/pulse", None);
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
        Tmpfs "/home";
        Tmpfs "/home/jail";
        Setenv ("HOME", "/home/jail");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Setenv ("MOZ_ENABLE_WAYLAND", "1");
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
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
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ [
        Dev_bind ("/dev/snd", None);
        Ro_bind ("/run/user/1000/bus", None);
        Ro_bind ("/run/user/1000/pulse", None);
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
        Ro_bind ("/opt/discord", None);
        Bind (get_jail_dir "discord", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
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
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ [
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
        Bind (get_jail_dir "thunderbird", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
        Bind ("$HOME/.thunderbird", Some "/home/jail/.thunderbird");
        Bind ("$HOME/.cache/thunderbird", Some "/home/jail/.cache/thunderbird");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        New_session;
      ];
  }

let chromium : profile =
  {
    name = "chromium";
    cmd = "/usr/lib/chromium/chromium";
    (* cmd = "glxinfo"; *)
    home_jail_dir = Some "chromium";
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ [
        Dev_bind ("/dev/dri/card0", None);
        Dev_bind ("/dev/snd", None);
        (* Ro_bind ("/run/dbus/system_bus_socket", None); *)
        Ro_bind ("/run/user/1000/bus", None);
        Ro_bind ("/run/user/1000/pulse", None);
        Bind ("/run/user/1000/dconf", None);
        Tmpfs "/home";
        Bind (get_jail_dir "chromium", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
        Chdir "/home/jail";
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        New_session;
      ];
  }

let suite =
  [
    bash;
    make_firefox_profile ~suffix:None;
    firefox_private;
    discord;
    thunderbird;
    chromium;
  ]
