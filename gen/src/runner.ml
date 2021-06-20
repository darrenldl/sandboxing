let write_c_file ~name ~prog ~proc_limit ~heap_limit_MiB =
  FileUtil.mkdir ~parent:true Config.runner_output_dir;
  let file_name = FilePath.concat Config.runner_output_dir (name ^ ".c") in
  CCIO.with_out file_name (fun oc ->
      let write_line = CCIO.write_line oc in
      write_line "#include <stdio.h>";
      write_line "#include <unistd.h>";
      write_line "#include <sys/resource.h>";
      write_line "#include <sys/types.h>";
      write_line "";
      write_line "int main(int _argc, char * argv[]) {";
      Option.iter
        (fun n ->
          write_line
            (Printf.sprintf
               "  struct rlimit lim_nproc = { .rlim_cur = %d, .rlim_max = %d};"
               n n);
          write_line
            "  if (setrlimit(RLIMIT_NPROC, &lim_nproc) != 0) { return 1; }")
        proc_limit;
      Option.iter
        (fun heap_limit_MiB ->
          let n = heap_limit_MiB * 1024 * 1024 in
          write_line
            (Printf.sprintf
               "  struct rlimit lim_data = { .rlim_cur = %d, .rlim_max = %d};" n
               n);
          write_line
            "  if (setrlimit(RLIMIT_DATA, &lim_data) != 0) { return 1; }")
        heap_limit_MiB;
      write_line (Printf.sprintf "  return execv(\"%s\", argv);" prog);
      write_line "}";
      write_line "");
  FileUtil.chmod (`Octal 0o664) [ file_name ]
