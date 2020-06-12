open Bw_script

let bash : profile =
  {
    name = "bash";
    cmd = "bash";
    use_home_jail = true;
    args = [ Ro_bind ("/", None) ];
  }
