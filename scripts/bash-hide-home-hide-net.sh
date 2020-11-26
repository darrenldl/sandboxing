#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/bash-hide-home-hide-net.c -lseccomp -o "$script_dir"/../seccomp-bpf/bash-hide-home-hide-net.exe
"$script_dir"/../seccomp-bpf/bash-hide-home-hide-net.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv bash-hide-home-hide-net_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

mkdir -p "$HOME/sandboxes/bash-hide-home-hide-net"
mkdir -p "$HOME/sandboxes/bash-hide-home-hide-net/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
bash "$script_dir"/bash-hide-home-hide-net.runner "$@"
