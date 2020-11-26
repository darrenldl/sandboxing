#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/chromium.c -lseccomp -o "$script_dir"/../seccomp-bpf/chromium.exe
"$script_dir"/../seccomp-bpf/chromium.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv chromium_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

mkdir -p "$HOME/sandboxes/chromium"
mkdir -p "$HOME/sandboxes/chromium/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
"$script_dir"/chromium.runner "$@"
