open Bwrap
open Profile_components

let bash : Profile.t =
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
    allow_network = true;
    aa_caps = [];
  }

let bash_hide_home : Profile.t =
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
    allow_network = true;
    aa_caps = [];
  }

let bash_hide_home_hide_net : Profile.t =
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
    allow_network = false;
    aa_caps = [];
  }

let bash_loose_hide_home : Profile.t =
  let name = "bash-loose-hide-home" in
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
      @ [ Unshare_user; Unshare_pid; Unshare_uts; Unshare_ipc; Unshare_cgroup ];
    allow_network = true;
    aa_caps = [];
  }

let make_firefox_profile
    ~(suffix : string option) : Profile.t =
  let name = match suffix with None -> "firefox" | Some s -> "firefox-" ^ s in
  {
    name;
    cmd =
      "/usr/lib/firefox/firefox --no-remote"
        ;
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
    allow_network = true;
    aa_caps = [];
  }

let firefox_private : Profile.t =
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
    allow_network = true;
    aa_caps = [];
  }

let discord : Profile.t =
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
    allow_network = true;
    aa_caps = [];
  }

let thunderbird : Profile.t =
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
    allow_network = true;
    aa_caps = [];
  }

let chromium : Profile.t =
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
    allow_network = true;
    aa_caps = [];
  }

let deluge : Profile.t =
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
    allow_network = true;
    aa_caps = [];
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

let okular_ro : Profile.t =
  let name = "okular-ro" in
  let pdf_file_in_home =
    Filename.concat Config.home_inside_jail "$(basename \"$1\")"
  in
  {
    name;
    cmd = Printf.sprintf "/usr/bin/okular \"%s\"" pdf_file_in_home;
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
    allow_network = false;
    aa_caps = [];
  }

let okular_rw : Profile.t =
  let name = "okular-rw" in
  let pdf_file_in_home =
    Filename.concat Config.home_inside_jail "$(basename \"$1\")"
  in
  {
    name;
    cmd = Printf.sprintf "/usr/bin/okular \"%s\"" pdf_file_in_home;
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
        Bind ("$1", Some pdf_file_in_home);
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        Unshare_net;
        New_session;
      ];
    allow_network = false;
    aa_caps = [];
  }

let eom_ro : Profile.t =
  let name = "eom-ro" in
  let image_file_in_home =
    Filename.concat Config.home_inside_jail "$(basename \"$1\")"
  in
  {
    name;
    cmd = Printf.sprintf "/usr/bin/eom \"%s\"" image_file_in_home;
    home_jail_dir = None;
    preserved_temp_home_dirs = [];
    log_stdout = true;
    log_stderr = true;
    syscall_blacklist = default_syscall_blacklist;
    args =
      usr_share_common
      @ usr_lib_lib64_common
      @ paths_of_binary "eom"
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
        Ro_bind ("$1", Some image_file_in_home);
        Hostname "jail";
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        Unshare_net;
        New_session;
      ];
    allow_network = false;
    aa_caps = [];
  }

let archive_handling : Profile.t =
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
    allow_network = false;
    aa_caps = [];
  }

let make_workspace : Profile.t =
  let name = "make-workspace" in
  {
    name;
    cmd = "/usr/bin/bash";
    home_jail_dir = Some (name ^ "-$1");
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
      @ set_up_jail_home ~tmp:false ~name:(name ^ "-$1")
      @ [
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
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
    allow_network = true;
    aa_caps = [];
  }

let suite =
  [
    bash;
    bash_hide_home;
    bash_hide_home_hide_net;
    bash_loose_hide_home;
    make_firefox_profile ~suffix:None;
    make_firefox_profile ~suffix:(Some "school");
    make_firefox_profile ~suffix:(Some "bank");
    make_firefox_profile ~suffix:(Some "google-play-book");
    firefox_private;
    discord;
    thunderbird;
    chromium;
    deluge;
    (* zoom; *)
    okular_ro;
    okular_rw;
    eom_ro;
    archive_handling;
    make_workspace;
  ]
