#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/make-workspace.c -lseccomp -o "$script_dir"/../seccomp-bpf/make-workspace.exe
"$script_dir"/../seccomp-bpf/make-workspace.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv make-workspace_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

mkdir -p "$HOME/sandboxes/make-workspace-$1"
mkdir -p "$HOME/sandboxes/make-workspace-$1/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
./make-workspace.runner "$@"
