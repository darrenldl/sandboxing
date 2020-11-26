#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/okular-rw.c -lseccomp -o "$script_dir"/../seccomp-bpf/okular-rw.exe
"$script_dir"/../seccomp-bpf/okular-rw.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv okular-rw_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

cur_time=$(date "+%Y-%m-%d_%H%M%S")
mkdir -p "$HOME/sandbox-logs/okular-rw"
stdout_log_name="$HOME/sandbox-logs/okular-rw"/"$cur_time"."stdout"

mkdir -p "$HOME/sandbox-logs/okular-rw"
stderr_log_name="$HOME/sandbox-logs/okular-rw"/"$cur_time"."stderr"

export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
"$script_dir"/okular-rw.runner "$@"
