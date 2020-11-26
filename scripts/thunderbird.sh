#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/thunderbird.c -lseccomp -o "$script_dir"/../seccomp-bpf/thunderbird.exe
"$script_dir"/../seccomp-bpf/thunderbird.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv thunderbird_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

mkdir -p "$HOME/sandboxes/thunderbird"
mkdir -p "$HOME/sandboxes/thunderbird/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
bash "$script_dir"/thunderbird.runner "$@"
