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
        Unshare_user;
        Uid None;
        Gid None;
        Tmpfs "/home";
        Bind (get_jail_dir "bash", Some "/home/jail");
        Setenv ("HOME", "/home/jail");
      ];
  }
