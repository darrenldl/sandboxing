#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/archive-handling.c -lseccomp -o "$script_dir"/../seccomp-bpf/archive-handling.exe
"$script_dir"/../seccomp-bpf/archive-handling.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv archive-handling_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

mkdir -p "$HOME/sandboxes/archive-handling"
mkdir -p "$HOME/sandboxes/archive-handling/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
./archive-handling.runner "$@"
