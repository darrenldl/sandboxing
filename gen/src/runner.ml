let write_c_file ~name ~prog ~heap_limit_MiB =
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
      (match heap_limit_MiB with
       | None -> ()
       | Some heap_limit_MiB ->
         let n = heap_limit_MiB * 1024 * 1024 in
         write_line
           (Printf.sprintf
              "  struct rlimit lim = { .rlim_cur = %d, .rlim_max = %d};" n n);
         write_line "  if (setrlimit(RLIMIT_DATA, &lim) != 0) { return 1; }");
      write_line (Printf.sprintf "  return execv(\"%s\", argv);" prog);
      write_line "}";
      write_line "");
  FileUtil.chmod (`Octal 0o664) [ file_name ]
