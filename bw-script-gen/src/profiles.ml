open Bw_script
open Profile_components

let bash : profile =
  {
    name = "bash";
    cmd = "bash";
    home_jail_dir = Some "bash";
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ lsb_release_common
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
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ sound_common
      @ wayland_common
      @ dconf_common
      @ dbus_common
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
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ sound_common
      @ wayland_common
      @ dconf_common
      @ dbus_common
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
    cmd = "/usr/bin/discord";
    home_jail_dir = Some name;
    syscall_blacklist = [];
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ sound_common
      @ x11_common
      @ dconf_common
      @ dbus_common
      @ [ Ro_bind ("/opt/discord", None) ]
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
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ wayland_common
      @ dconf_common
      @ set_up_jail_home ~tmp:false ~name
      @ [
        Bind ("$HOME/.thunderbird", Some "/home/jail/.thunderbird");
        Bind ("$HOME/.cache/thunderbird", Some "/home/jail/.cache/thunderbird");
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

let chromium : profile =
  let name = "chromium" in
  {
    name;
    cmd = "/usr/lib/chromium/chromium";
    (* cmd = "glxinfo"; *)
    home_jail_dir = Some name;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ sound_common
      @ wayland_common
      @ dconf_common
      @ dbus_common
      @ [ Dev_bind ("/dev/dri/card0", None) ]
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

let deluge =
  let name = "deluge" in
  {
    name;
    cmd = "/usr/bin/deluge";
    home_jail_dir = Some name;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ wayland_common
      @ dconf_common
      @ dbus_common
      @ lsb_release_common
      @ set_up_jail_home ~tmp:false ~name
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

let suite =
  [
    bash;
    make_firefox_profile ~suffix:None;
    firefox_private;
    discord;
    thunderbird;
    chromium;
    deluge;
  ]
