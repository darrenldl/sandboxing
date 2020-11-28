let write_c_file ~name ~prog =
  FileUtil.mkdir ~parent:true Config.runner_output_dir;
  let file_name = FilePath.concat Config.runner_output_dir (name ^ ".c") in
  CCIO.with_out file_name (fun oc ->
      let write_line = CCIO.write_line oc in
      write_line "#include <stdio.h>";
      write_line "#include <unistd.h>";
      write_line "";
      write_line "int main(int _argc, char * argv[]) {";
      write_line (Printf.sprintf "  return execv(\"%s\", argv);" prog);
      write_line "}";
      write_line "");
  FileUtil.chmod (`Octal 0o664) [ file_name ]
