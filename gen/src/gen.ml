let write_main_script (p : Profile.t) : unit =
  FileUtil.mkdir ~parent:true Config.script_output_dir;
  let file_name = FilePath.concat Config.script_output_dir (p.name ^ ".sh") in
  CCIO.with_out file_name (fun oc ->
      let write_line = CCIO.write_line oc in
      write_line "#!/usr/bin/bash";
      write_line "";
      write_line "set -euxo pipefail";
      write_line "";
      write_line (Printf.sprintf "script_dir=$(dirname $(readlink -f \"$0\"))");
      write_line "";
      let bpf_dir =
        Printf.sprintf "\"$script_dir\"/%s" Config.seccomp_bpf_output_dir
      in
      let bin_file_path =
        Printf.sprintf "\"$script_dir\"/%s/%s" Config.seccomp_bpf_output_dir
          p.name
      in
      write_line
        (Printf.sprintf "gcc %s.c -lseccomp -o %s.exe" bin_file_path
           bin_file_path);
      write_line (Printf.sprintf "%s.exe" bin_file_path);
      write_line "if [[ $? != 0 ]]; then";
      write_line "  echo \"Failed to generate seccomp filter\"";
      write_line "  exit 1";
      write_line "fi";
      write_line "";
      write_line
        (Printf.sprintf "mv %s%s %s" p.name Config.seccomp_bpf_suffix bpf_dir);
      write_line "";
      ( match p.home_jail_dir with
        | None -> ()
        | Some s ->
          let jail_dir = Filename.concat Config.jails_dir s in
          let downloads_dir = Filename.concat jail_dir "Downloads" in
          write_line (Printf.sprintf "mkdir -p \"%s\"" jail_dir);
          write_line (Printf.sprintf "mkdir -p \"%s\"" downloads_dir);
          write_line "" );
      let log_dir = Filename.concat Config.jail_logs_dir p.name in
      write_line
        (Printf.sprintf "cur_time=$(date \"%s\")" Config.log_date_format_str);
      if p.log_stdout then (
        write_line (Printf.sprintf "mkdir -p \"%s\"" log_dir);
        write_line
          (Printf.sprintf "stdout_log_name=\"%s\"/\"$cur_time\".\"%s\"" log_dir
             Config.stdout_log_suffix);
        write_line "" );
      if p.log_stderr then (
        write_line (Printf.sprintf "mkdir -p \"%s\"" log_dir);
        write_line
          (Printf.sprintf "stderr_log_name=\"%s\"/\"$cur_time\".\"%s\"" log_dir
             Config.stderr_log_suffix);
        write_line "" );
      ( match p.preserved_temp_home_dirs with
        | [] -> ()
        | _ ->
          write_line
            (Printf.sprintf "tmp_dir=$(mktemp -d -t %s-$cur_time-XXXX)" p.name);
          List.iter
            (fun dir ->
               write_line
                 (Printf.sprintf "mkdir -p \"%s\""
                    (Filename.concat "$tmp_dir" dir)))
            p.preserved_temp_home_dirs;
          write_line "" );
      (* write_line "export script_dir";
       * write_line "export tmp_dir";
       * write_line "export stdout_log_name";
       * write_line "export stderr_log_name"; *)
      write_line "( exec bwrap \\";
      List.iter
        (fun x -> write_line (Printf.sprintf "  %s \\" (Bwrap.compile_arg x)))
        Bwrap.(
          p.args
          @ List.map
            (fun dir ->
               Bind
                 ( Filename.concat "$tmp_dir" dir,
                   Some (Filename.concat Config.home_inside_jail dir) ))
            p.preserved_temp_home_dirs
          @ ( match p.syscall_blacklist with
              | [] -> []
              | _ ->
                [
                  Seccomp
                    (Filename.concat bpf_dir
                       (p.name ^ Config.seccomp_bpf_suffix));
                ] )
          @ [
            Ro_bind ("/usr/bin/bash", None);
            Ro_bind
              ( Printf.sprintf "$script_dir/%s.runner" p.name,
                Some
                  (Filename.concat Config.home_inside_jail
                     (Printf.sprintf "%s.runner" p.name)) );
          ]);
      write_line
        (Printf.sprintf "  %s/%s.runner \"$@\" \\" Config.home_inside_jail
           p.name);
      if p.log_stdout then write_line "  >$stdout_log_name \\";
      if p.log_stderr then write_line "  2>$stderr_log_name \\";
      write_line " )";
      match p.preserved_temp_home_dirs with
      | [] -> ()
      | _ ->
        write_line "";
        List.iter
          (fun dir ->
             write_line
               (Printf.sprintf "rmdir --ignore-fail-on-non-empty \"%s\""
                  (Filename.concat "$tmp_dir" dir)))
          p.preserved_temp_home_dirs;
        write_line
          (Printf.sprintf "rmdir --ignore-fail-on-non-empty \"$tmp_dir\""));
  FileUtil.chmod (`Octal 0o774) [ file_name ]

let write_runner_script (p : Profile.t) : unit =
  FileUtil.mkdir ~parent:true Config.script_output_dir;
  let file_name =
    FilePath.concat Config.script_output_dir (p.name ^ ".runner")
  in
  CCIO.with_out file_name (fun oc ->
      let write_line = CCIO.write_line oc in
      write_line "#!/usr/bin/bash";
      write_line "";
      write_line "set -euxo pipefail";
      write_line "";
      write_line (Printf.sprintf "%s \"$@\"" p.cmd));
  FileUtil.chmod (`Octal 0o774) [ file_name ]

let write_seccomp_bpf (p : Profile.t) : unit =
  Seccomp_bpf.write_c_file ~name:p.name ~blacklist:p.syscall_blacklist

let write_aa_profile (p : Profile.t) : unit =
  FileUtil.mkdir ~parent:true Config.aa_profile_output_dir;
  let file_name =
    FilePath.concat Config.aa_profile_output_dir
      (Printf.sprintf "home.sandboxing.%s" p.name)
  in
  CCIO.with_out file_name (fun oc ->
      let write_line = CCIO.write_line oc in
      write_line "#include <tunables/global>";
      write_line "";
      write_line
        (Printf.sprintf
           "profile /home/sandbox/%s.runner {"
           p.name);
      write_line "  include <abstractions/base>";
      write_line "";
      ( match p.aa_caps with
        | [] -> ()
        | l ->
          List.iter
            (fun x ->
               write_line
                 (Printf.sprintf "  capability %s," (Aa.string_of_capability x)))
            l;
          write_line "" );
      write_line "  # Runner self access";
      write_line
        (Printf.sprintf "  /home/sandbox/%s.runner r," p.name);
      write_line "";
      write_line "  # Sandbox access";
      write_line (Printf.sprintf "  /home/sandbox/ r,");
      write_line (Printf.sprintf "  /home/sandbox/** rwlk,");
      write_line "";
      write_line "  /usr/bin/env ix,";
      write_line "";
      write_line "  / r,";
      write_line "";
      write_line "  unix,";
      write_line "  deny unix addr=@/tmp/.X11-unix/**,";
      write_line "";
      if p.allow_network then (
        write_line "  network,";
        write_line "" );
      write_line "  dbus bus=session,";
      write_line "";
      (* write_line "  set rlimit nproc <= 200,";
       * write_line ""; *)
      write_line "  # Programs and libraries";
      write_line "  /usr/ r,";
      write_line "  /{,usr/,usr/local/}{,s}bin/ r,";
      write_line "  /{,usr/,usr/local/}{,s}bin/** rpix,";
      write_line "  /{,usr/,usr/local/}lib{,32,64}/ r,";
      write_line "  /{,usr/,usr/local/}lib{,32,64}/** rmpix,";
      write_line "  /usr/{,local/}{share,include}/ r,";
      write_line "  /usr/{,local/}{share,include}/** rpix,";
      write_line "";
      write_line "  # Sysfs";
      write_line "  /sys/ r,";
      write_line "  /sys/devices/ r,";
      write_line "  /sys/devices/**/{uevent,config} r,";
      write_line "  /sys/devices/pci[0-9]*/**/ r,";
      write_line
        "  \
         /sys/devices/pci[0-9]*/**/{resource,boot_vga,class,vendor,device,irq,revision,subsystem_vendor,port_no} \
         r,";
      write_line "  /sys/devices/pci[0-9]*/**/drm/**/{,enabled,status} r,";
      write_line "  /sys/devices/pci[0-9]*/**/sound/**/pcm_class r,";
      write_line "  /sys/devices/pci[0-9]*/**/backlight/**/* r,";
      write_line "  /sys/devices/virtual/tty/tty[0-9]*/active r,";
      write_line "  /sys/devices/virtual/tty/console/active r,";
      write_line "  /sys/devices/virtual/dmi/id/{sys,board,bios}_vendor r,";
      write_line "  /sys/devices/virtual/dmi/id/product_name r,";
      write_line "  /sys/devices/system/node/ r,";
      write_line "  /sys/devices/system/node/node[0-9]*/meminfo r,";
      write_line "  /sys/devices/system/cpu/ r,";
      write_line "  /sys/devices/system/cpu/{present,online} r,";
      write_line "  /sys/devices/system/cpu/cpu[0-9]*/cache/index2/size r,";
      write_line "  /sys/class/ r,";
      write_line "  /sys/class/{tty,input,drm,sound}/ r,";
      write_line "  /sys/bus/ r,";
      write_line "  /sys/bus/pci/devices/ r,";
      write_line "  /sys/fs/cgroup/** rw,";
      write_line "";
      write_line "  # Procfs";
      write_line "  @{PROC}/ r,";
      write_line
        "  owner \
         @{PROC}/[0-9]*/{cgroup,cmdline,comm,sessionid,mounts,stat,status,sched,maps,auxv,attr/current,fd/,environ,limits,mountinfo,task/,task/*/stat,task/*/status,fdinfo/*,mem} \
         r,";
      write_line
        "  owner \
         @{PROC}/@{pid}/{cgroup,cmdline,comm,sessionid,mounts,stat,status,sched,maps,auxv,attr/current,fd/,environ,limits,mountinfo,task/,task/*/stat,task/*/status,fdinfo/*,mem} \
         r,";
      write_line
        "  owner \
         @{PROC}/@{pid}/{setgroups,gid_map,uid_map,attr/exec,oom_score_adj} \
         rw,";
      write_line "  @{PROC}/{stat,cpuinfo,filesystems,meminfo,swaps,uptime} r,";
      write_line "  @{PROC}/sys/** r,";
      write_line "  deny /proc/*/{statm,smaps} r,";
      write_line "  deny /proc/*/net/ r,";
      write_line "  deny /proc/*/net/** r,";
      write_line "";
      write_line "  # Tmpfs";
      write_line "  /{,var/}tmp/ r,";
      write_line "  /{,var/}tmp/** r,";
      write_line "  owner /{,var/}tmp/ rw,";
      write_line "  owner /{,var/}tmp/** rw,";
      write_line "";
      write_line "  # /etc";
      write_line "  /etc/ r,";
      write_line "  /etc/** r,";
      write_line "";
      write_line "  # Device access";
      write_line "  /dev/ r,";
      write_line "  /dev/console r,";
      write_line "  /dev/random rw,";
      write_line "  /dev/urandom rw,";
      write_line "  /dev/null rw,";
      write_line "  /dev/zero rw,";
      write_line "  /dev/full rw,";
      write_line "  owner /dev/stdin rw,";
      write_line "  owner /dev/stdout r,";
      write_line "  owner /dev/stderr rw,";
      write_line "  /dev/tty rw,";
      write_line "  owner /dev/ptmx rw,";
      write_line "  /dev/pts/ r,";
      write_line "  owner /dev/pts/* rw,";
      write_line "  owner /dev/shm/ r,";
      write_line "  owner /dev/shm/** rw,";
      write_line "  /dev/video* rw,";
      write_line "  /dev/snd/ r,";
      write_line "  /dev/snd/** rw,";
      write_line "";
      write_line "  # /var and /run";
      write_line "  /var/ r,";
      write_line "  /var/{lib,cache}/ r,";
      write_line "  /var/lib/** r,";
      write_line "  /var/lib/command-not-found/commands.db rwk,";
      write_line "  /var/cache/** rwl,";
      write_line "  owner /var/lib/ rw,";
      write_line "  owner /var/lib/** rw,";
      write_line "  /{,var/}run/ r,";
      write_line "  /{,var/}run/** rw,";
      write_line "  /{,var/}run/shm/** rwl,";
      write_line "  owner /{,var/}run/** rwk,";
      write_line "";
      write_line "  # Prevent leak of some important kernel info";
      write_line "  deny /{,usr/}lib/modules/ rw,";
      write_line "  deny /{,usr/}lib/modules/** rw,";
      write_line "  deny /**vmlinu{,z,x}* rw,";
      write_line "  deny /**System.map* rw,";
      write_line "";
      write_line "}");
  FileUtil.chmod (`Octal 0o774) [ file_name ];
  ()

let () =
  List.iter
    (fun p ->
       write_main_script p;
       write_runner_script p;
       write_seccomp_bpf p;
       write_aa_profile p)
    Profiles.suite
