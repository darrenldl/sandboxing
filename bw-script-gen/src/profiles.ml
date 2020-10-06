open Bw_script
open Profile_components

let bash : profile =
  {
    name = "bash";
    cmd = "/usr/bin/bash";
    home_jail_dir = Some "bash";
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      [ Ro_bind ("/usr/share", None) ]
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ set_up_jail_home ~tmp:false ~name:"bash"
      @ [
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        New_session;
      ];
  }

let bash_hide_home : profile =
  let name = "bash-hide-home" in
  {
    name;
    cmd = "/usr/bin/bash";
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      [ Ro_bind ("/usr/share", None) ]
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ set_up_jail_home ~tmp:false ~name
      @ [
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        New_session;
      ];
  }

let bash_hide_home_hide_net : profile =
  let name = "bash-hide-home-hide-net" in
  {
    name;
    cmd = "/usr/bin/bash";
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      [ Ro_bind ("/usr/share", None) ]
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ set_up_jail_home ~tmp:false ~name
      @ dbus_common
      @ [
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        Unshare_net;
        New_session;
      ];
  }

let make_firefox_profile ~(use_main_user_profile : bool)
    ~(suffix : string option) : profile =
  let name = match suffix with None -> "firefox" | Some s -> "firefox-" ^ s in
  {
    name;
    cmd =
      ( if use_main_user_profile then
          "/usr/lib/firefox/firefox --ProfileManager --no-remote"
        else "/usr/lib/firefox/firefox --no-remote" );
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_common
      @ paths_of_binary "firefox"
      @ etc_common
      @ etc_ssl
      @ etc_localtime
      @ proc_dev_common
      @ tmp_run_common
      @ sound_common
      @ wayland_common
      @ dconf_common
      @ dbus_common
      @ set_up_jail_home ~tmp:false ~name
      @ ( if use_main_user_profile then
            [
              Bind
                ( "$HOME/.mozilla",
                  Some (Printf.sprintf "%s/.mozilla" Config.home_inside_jail) );
              Bind
                ( "$HOME/.cache/mozilla",
                  Some
                    (Printf.sprintf "%s/.cache/mozilla" Config.home_inside_jail)
                );
            ]
          else [] )
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

let firefox_private : profile =
  let name = "firefox-private" in
  {
    name;
    cmd = "/usr/lib/firefox/firefox --no-remote";
    home_jail_dir = None;
    preserved_temp_home_dirs = [ "Downloads" ];
    log_stdout = true;
    log_stderr = true;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_common
      @ paths_of_binary "firefox"
      @ etc_common
      @ etc_ssl
      @ etc_localtime
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
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      (* @ usr_lib_lib64_common
         @ paths_of_binary "discord"
         @ paths_of_binary "firefox"
         @ paths_of_binary "electron" *)
      @ etc_common
      @ etc_ssl
      @ etc_localtime
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
        Setenv ("QT_X11_NO_MITSHM", "1");
        Setenv ("_X11_NO_MITSHM", "1");
        Setenv ("_MITSHM", "0");
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        (* Unshare_ipc; *)
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
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ etc_ssl
      @ etc_localtime
      @ proc_dev_common
      @ tmp_run_common
      @ wayland_common
      @ dconf_common
      @ dbus_common
      @ set_up_jail_home ~tmp:false ~name
      @ [
        Bind
          ( "$HOME/.thunderbird",
            Some (Printf.sprintf "%s/.thunderbird" Config.home_inside_jail) );
        Bind
          ( "$HOME/.cache/thunderbird",
            Some
              (Printf.sprintf "%s/.cache/thunderbird" Config.home_inside_jail)
          );
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
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ etc_ssl
      @ etc_localtime
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
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ etc_ssl
      @ etc_localtime
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

(* let zoom : profile =
 *   let name = "zoom" in
 *   {
 *     name;
 *     cmd = "/usr/bin/zoom";
 *     home_jail_dir = Some name;
 *     preserved_temp_home_dirs = [];
 *     syscall_blacklist = default_syscall_blacklist;
 *     args =
 *       [ Ro_bind ("/usr/share", None) ]
 *       @ usr_lib_lib64_bin_common
 *       @ etc_common
 *       @ proc_dev_common
 *       @ tmp_run_common
 *       @ sound_common
 *       @ x11_common
 *       @ wayland_common
 *       @ dconf_common
 *       @ dbus_common
 *       @ set_up_jail_home ~tmp:false ~name
 *       @ [
 *         Ro_bind
 *           (Filename.concat (get_jail_dir name) "opt/zoom", Some "/opt/zoom");
 *         Symlink ("/opt/zoom/ZoomLauncher", Some "/usr/bin/zoom");
 *         (\* Ro_bind ((Filename.concat (get_jail_dir name) "usr/share/mime/packages/zoom.xml"),
 *              Some "/usr/share/mime/packages/zoom.xml");
 *            Ro_bind ((Filename.concat (get_jail_dir name) "usr/share/pixmaps/application-x-zoom.png"),
 *              Some "/usr/share/pixmaps/application-x-zoom.png");
 *            Ro_bind ((Filename.concat (get_jail_dir name) "usr/share/pixmaps/Zoom.png"),
 *              Some "/usr/share/pixmaps/Zoom.png"); *\)
 *         Remount_ro "/usr/share";
 *         Unsetenv "DBUS_SESSION_BUS_ADDRESS";
 *         Setenv ("SHELL", "/usr/bin/bash");
 *         Setenv ("USER", "nobody");
 *         Setenv ("LOGNAME", "nobody");
 *         Hostname "jail";
 *         Unshare_user;
 *         Unshare_pid;
 *         Unshare_uts;
 *         Unshare_ipc;
 *         Unshare_cgroup;
 *         New_session;
 *       ];
 *   } *)

let okular_ro : profile =
  let name = "okular-ro" in
  let pdf_file_in_home =
    Filename.concat Config.home_inside_jail "$(basename $1)"
  in
  {
    name;
    cmd = Printf.sprintf "/usr/bin/okular %s" pdf_file_in_home;
    home_jail_dir = None;
    preserved_temp_home_dirs = [];
    log_stdout = true;
    log_stderr = true;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_common
      @ paths_of_binary "okular"
      @ etc_common
      @ etc_ssl
      @ etc_localtime
      @ proc_dev_common
      @ tmp_run_common
      @ wayland_common
      @ set_up_jail_home ~tmp:true ~name
      @ [
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("SHELL", "/bin/false");
        Setenv ("USER", "nobody");
        Setenv ("LOGNAME", "nobody");
        Ro_bind ("$1", Some pdf_file_in_home);
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        Unshare_net;
        New_session;
      ];
  }

let archive_handling : profile =
  let name = "archive-handling" in
  {
    name;
    cmd = "/usr/bin/bash";
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ etc_ssl
      @ etc_localtime
      @ proc_dev_common
      @ tmp_run_common
      @ wayland_common
      @ set_up_jail_home ~tmp:true ~name
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
        Unshare_net;
        New_session;
      ];
  }

let suite =
  [
    bash;
    bash_hide_home;
    bash_hide_home_hide_net;
    make_firefox_profile ~use_main_user_profile:true ~suffix:None;
    make_firefox_profile ~use_main_user_profile:false ~suffix:(Some "school");
    make_firefox_profile ~use_main_user_profile:false ~suffix:(Some "bank");
    make_firefox_profile ~use_main_user_profile:false
      ~suffix:(Some "google-play-book");
    firefox_private;
    discord;
    thunderbird;
    chromium;
    deluge;
    (* zoom; *)
    okular_ro;
    archive_handling;
  ]
