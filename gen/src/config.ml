let jails_dir = "$HOME/sandboxes"

let jail_logs_dir = "$HOME/sandbox-logs"

let stdout_log_suffix = "stdout"

let stderr_log_suffix = "stderr"

let log_date_format_str = "+%Y-%m-%d_%H%M%S"

let home_inside_jail = "/home/sandbox"

let aa_profile_output_dir = "../aa-profiles"

let script_output_dir = "../scripts"

let seccomp_bpf_output_dir = "../seccomp-bpfs"

let seccomp_bpf_suffix = "_seccomp_filter.bpf"

let runner_output_dir = "../runners"

let runner_suffix = ".runner"

let firefox_hardened_pref_path =
  "$script_dir/../firefox-hardening/local-settings.js"

let firefox_hardened_user_js_path =
  "$script_dir/../firefox-hardening/systemwide_user.js"
