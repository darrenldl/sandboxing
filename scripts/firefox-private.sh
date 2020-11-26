#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/firefox-private.c -lseccomp -o "$script_dir"/../seccomp-bpf/firefox-private.exe
"$script_dir"/../seccomp-bpf/firefox-private.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv firefox-private_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

cur_time=$(date "+%Y-%m-%d_%H%M%S")
mkdir -p "$HOME/sandbox-logs/firefox-private"
stdout_log_name="$HOME/sandbox-logs/firefox-private"/"$cur_time"."stdout"

mkdir -p "$HOME/sandbox-logs/firefox-private"
stderr_log_name="$HOME/sandbox-logs/firefox-private"/"$cur_time"."stderr"

tmp_dir=$(mktemp -d -t firefox-private-$cur_time-XXXX)
mkdir -p "$tmp_dir/Downloads"

export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
"$script_dir"/firefox-private.runner "$@"
