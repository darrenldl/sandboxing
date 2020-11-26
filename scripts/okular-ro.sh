#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/okular-ro.c -lseccomp -o "$script_dir"/../seccomp-bpf/okular-ro.exe
"$script_dir"/../seccomp-bpf/okular-ro.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv okular-ro_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

cur_time=$(date "+%Y-%m-%d_%H%M%S")
mkdir -p "$HOME/sandbox-logs/okular-ro"
stdout_log_name="$HOME/sandbox-logs/okular-ro"/"$cur_time"."stdout"

mkdir -p "$HOME/sandbox-logs/okular-ro"
stderr_log_name="$HOME/sandbox-logs/okular-ro"/"$cur_time"."stderr"

export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
bash "$script_dir"/okular-ro.runner "$@"
