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
      ]
      @ set_up_jail_home ~tmp:false ~name:"bash";
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
      ]
      @ set_up_jail_home ~tmp:false ~name
      @ [
        Bind ("$HOME/.mozilla", Some "/home/jail/.mozilla");
        Bind ("$HOME/.cache/mozilla", Some "/home/jail/.cache/mozilla");
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
  let name = "firefox-private" in
  {
    name;
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
        Ro_bind ("/run/user/1000/bus", None);
        Ro_bind ("/run/user/1000/pulse", None);
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
      ]
      @ set_up_jail_home ~tmp:true ~name
      @ [
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
  let name = "discord" in
  {
    name;
    cmd = "/opt/discord/Discord";
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
        Ro_bind ("/opt/discord", None);
      ]
      @ set_up_jail_home ~tmp:false ~name
      @ [
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
  let name = "thunderbird" in
  {
    name;
    cmd = "/usr/lib/thunderbird/thunderbird";
    home_jail_dir = Some name;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ [
        Ro_bind ("/run/user/1000/wayland-0", None);
        Bind ("/run/user/1000/dconf", None);
      ]
      @ set_up_jail_home ~tmp:false ~name
      @ [
        Bind ("$HOME/.thunderbird", Some "/home/jail/.thunderbird");
        Bind ("$HOME/.cache/thunderbird", Some "/home/jail/.cache/thunderbird");
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
  let name = "chromium" in
  {
    name;
    cmd = "/usr/lib/chromium/chromium";
    (* cmd = "glxinfo"; *)
    home_jail_dir = Some name;
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
      ]
      @ set_up_jail_home ~tmp:false ~name
      @ [
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
