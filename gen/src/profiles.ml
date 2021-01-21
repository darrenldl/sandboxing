open Bwrap
open Profile_components

let bash : Profile.t =
  {
    name = "bash";
    prog = "/usr/bin/bash";
    args = [];
    home_jail_dir = None;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist;
    bwrap_args =
      [ Ro_bind ("/usr/share", None) ]
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ [
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("HOME", "/home/sandbox");
        Setenv ("USER", "sandbox");
        Setenv ("LOGNAME", "sandbox");
        Bind (".", Some Config.home_inside_jail);
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
      ];
    allow_network = true;
    aa_caps = [];
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 2048;
  }

let bash_hide_net : Profile.t =
  let name = "bash-hide-net" in
  {
    name;
    prog = "/usr/bin/bash";
    args = [];
    home_jail_dir = None;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist;
    bwrap_args =
      [ Ro_bind ("/usr/share", None) ]
      @ usr_lib_lib64_bin_common
      @ etc_common
      @ proc_dev_common
      @ tmp_run_common
      @ [
        Unsetenv "DBUS_SESSION_BUS_ADDRESS";
        Setenv ("HOME", "/home/sandbox");
        Setenv ("USER", "sandbox");
        Setenv ("LOGNAME", "sandbox");
        Bind (".", Some Config.home_inside_jail);
        Unshare_user;
        Unshare_pid;
        Unshare_uts;
        Unshare_ipc;
        Unshare_cgroup;
        Unshare_net;
      ];
    allow_network = false;
    aa_caps = [];
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 2048;
  }

let make_firefox_profile ~(suffix : string option) : Profile.t =
  let name = match suffix with None -> "firefox" | Some s -> "firefox-" ^ s in
  {
    name;
    prog = "/usr/lib/firefox/firefox";
    args = [ "--no-remote" ];
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist_wx;
    bwrap_args =
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
    aa_caps = Aa.[ Sys_admin; Sys_chroot; Sys_ptrace ];
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 1024;
  }

let firefox_tmp : Profile.t =
  let name = "firefox-tmp" in
  {
    name;
    prog = "/usr/lib/firefox/firefox";
    args = [ "--no-remote" ];
    home_jail_dir = None;
    preserved_temp_home_dirs = [ "Downloads" ];
    log_stdout = true;
    log_stderr = true;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist_wx;
    bwrap_args =
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
    aa_caps = Aa.[ Sys_admin; Sys_chroot; Sys_ptrace ];
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 512;
  }

let firefox_private : Profile.t =
  let name = "firefox-private" in
  {
    name;
    prog = "/usr/lib/firefox/firefox";
    args = [ "--no-remote" ];
    home_jail_dir = None;
    preserved_temp_home_dirs = [ "Downloads" ];
    log_stdout = true;
    log_stderr = true;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist_wx;
    bwrap_args =
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
        Ro_bind
          ( Config.firefox_hardened_user_js_path,
            Some "/etc/firefox/syspref.js" );
      ]
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
    aa_caps = Aa.[ Sys_admin; Sys_chroot; Sys_ptrace ];
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 1024;
  }

let firefox_private_arch : Profile.t =
  let name = "firefox-private-arch" in
  {
    name;
    prog = "/usr/lib/firefox/firefox";
    args = [ "--no-remote" ];
    home_jail_dir = None;
    preserved_temp_home_dirs = [ "Downloads" ];
    log_stdout = true;
    log_stderr = true;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist_wx;
    bwrap_args =
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
        Tmpfs "/usr/lib/firefox/";
        Ro_bind
          ( Config.firefox_hardened_user_js_path,
            Some "/usr/lib/firefox/mozilla.cfg" );
      ]
      @ [
        Ro_bind_as_is_glob "/usr/lib/firefox/*";
        Tmpfs "/usr/lib/firefox/defaults/pref/";
        Ro_bind
          ( Config.firefox_hardened_pref_path,
            Some "/usr/lib/firefox/defaults/pref/local-settings.js" );
      ]
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
    aa_caps = Aa.[ Sys_admin; Sys_chroot; Sys_ptrace ];
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 1024;
  }

let discord : Profile.t =
  let name = "discord" in
  {
    name;
    prog = "/usr/bin/discord";
    args = [];
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_default_action = "SCMP_ACT_ALLOW";
    syscall_blacklist = default_syscall_blacklist;
    syscall_whitelist = [];
    bwrap_args =
      usr_share_common
      @ usr_lib_lib64_bin_common
      @ disallow_browsers
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
    aa_caps = Aa.[ Sys_admin; Sys_chroot; Sys_ptrace ];
    allow_wx = true;
    extra_aa_lines = [ "/opt/discord/ r"; "/opt/discord/** rix" ];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 1024;
  }

let thunderbird : Profile.t =
  let name = "thunderbird" in
  {
    name;
    prog = "/usr/lib/thunderbird/thunderbird";
    args = [];
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist_wx;
    bwrap_args =
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
    allow_wx = false;
    extra_aa_lines = [ "deny /usr/lib/firefox/** x" ];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 1024;
  }

let chromium : Profile.t =
  let name = "chromium" in
  {
    name;
    prog = "/usr/lib/chromium/chromium";
    args = [];
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_default_action = "SCMP_ACT_ALLOW";
    syscall_blacklist = default_syscall_blacklist;
    syscall_whitelist = [];
    bwrap_args =
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
    aa_caps = [ Sys_admin; Sys_chroot; Sys_ptrace ];
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 2048;
  }

let chromium_tmp : Profile.t =
  let name = "chromium-tmp" in
  {
    name;
    prog = "/usr/lib/chromium/chromium";
    args = [];
    home_jail_dir = None;
    preserved_temp_home_dirs = [ "Downloads" ];
    log_stdout = false;
    log_stderr = false;
    syscall_default_action = "SCMP_ACT_ALLOW";
    syscall_blacklist = default_syscall_blacklist;
    syscall_whitelist = [];
    bwrap_args =
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
        New_session;
      ];
    allow_network = true;
    aa_caps = [ Sys_admin; Sys_chroot; Sys_ptrace ];
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 2048;
  }

let deluge : Profile.t =
  let name = "deluge" in
  {
    name;
    prog = "/usr/bin/deluge";
    args = [];
    home_jail_dir = Some name;
    preserved_temp_home_dirs = [];
    log_stdout = false;
    log_stderr = false;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist;
    bwrap_args =
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
    allow_wx = false;
    extra_aa_lines = [ "deny /usr/lib/firefox/** rx" ];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 200;
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
    prog = "/usr/bin/okular";
    args = [ Printf.sprintf "\"%s\"" pdf_file_in_home ];
    home_jail_dir = None;
    preserved_temp_home_dirs = [];
    log_stdout = true;
    log_stderr = true;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist_wx;
    bwrap_args =
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
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 200;
  }

let okular_rw : Profile.t =
  let name = "okular-rw" in
  let pdf_file_in_home =
    Filename.concat Config.home_inside_jail "$(basename \"$1\")"
  in
  {
    name;
    prog = "/usr/bin/okular";
    args = [ Printf.sprintf "\"%s\"" pdf_file_in_home ];
    home_jail_dir = None;
    preserved_temp_home_dirs = [];
    log_stdout = true;
    log_stderr = true;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist_wx;
    bwrap_args =
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
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 200;
  }

let eom_ro : Profile.t =
  let name = "eom-ro" in
  let image_file_in_home =
    Filename.concat Config.home_inside_jail "$(basename \"$1\")"
  in
  {
    name;
    prog = "/usr/bin/eom";
    args = [ Printf.sprintf "\"%s\"" image_file_in_home ];
    home_jail_dir = None;
    preserved_temp_home_dirs = [];
    log_stdout = true;
    log_stderr = true;
    syscall_default_action = "SCMP_ACT_KILL";
    syscall_blacklist = [];
    syscall_whitelist = default_syscall_whitelist;
    bwrap_args =
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
    allow_wx = false;
    extra_aa_lines = [];
    proc_limit = Some 2000;
    heap_limit_MiB = Some 200;
  }

let suite =
  [
    bash;
    bash_hide_net;
    make_firefox_profile ~suffix:None;
    (* make_firefox_profile ~suffix:(Some "school");
     * make_firefox_profile ~suffix:(Some "bank");
     * make_firefox_profile ~suffix:(Some "google-play-book"); *)
    firefox_tmp;
    firefox_private;
    firefox_private_arch;
    discord;
    thunderbird;
    chromium;
    chromium_tmp;
    deluge;
    (* zoom; *)
    okular_ro;
    okular_rw;
    eom_ro;
  ]
