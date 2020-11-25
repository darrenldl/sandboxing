let write_script (p : Profile.t) : unit =
  FileUtil.mkdir ~parent:true Config.script_output_dir;
  let file_name = FilePath.concat Config.script_output_dir (p.name ^ ".sh") in
  CCIO.with_out file_name (fun oc ->
      let write_line = CCIO.write_line oc in
      write_line "#!/usr/bin/env bash";
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
      write_line "( exec bwrap \\";
      List.iter
        (fun x ->
           write_line (Printf.sprintf "  %s \\" (Bwrap.compile_arg x)))
        ( p.args
          @ List.map
            (fun dir ->
               Bwrap.Bind
                 ( Filename.concat "$tmp_dir" dir,
                   Some (Filename.concat Config.home_inside_jail dir) ))
            p.preserved_temp_home_dirs
          @
          match p.syscall_blacklist with
          | [] -> []
          | _ ->
            [
              Seccomp
                (Filename.concat bpf_dir (p.name ^ Config.seccomp_bpf_suffix));
            ] );
      output_string oc (Printf.sprintf "  %s" p.cmd);
      if p.log_stdout then output_string oc " >$stdout_log_name";
      if p.log_stderr then output_string oc " 2>$stderr_log_name";
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
      write_line (Printf.sprintf "/home/**/sandboxing/scripts/%s.sh" p.name);
    );
  FileUtil.chmod (`Octal 0o774) [ file_name ];
  ()

let () =
  List.iter
    (fun p ->
       write_script p;
       write_seccomp_bpf p;
       write_aa_profile p)
    Profiles.suite
