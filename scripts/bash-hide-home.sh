#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/bash-hide-home.c -lseccomp -o "$script_dir"/../seccomp-bpf/bash-hide-home.exe
"$script_dir"/../seccomp-bpf/bash-hide-home.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv bash-hide-home_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

mkdir -p "$HOME/sandboxes/bash-hide-home"
mkdir -p "$HOME/sandboxes/bash-hide-home/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
"$script_dir"/bash-hide-home.runner "$@"
