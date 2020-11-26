#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/discord.c -lseccomp -o "$script_dir"/../seccomp-bpf/discord.exe
"$script_dir"/../seccomp-bpf/discord.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv discord_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

mkdir -p "$HOME/sandboxes/discord"
mkdir -p "$HOME/sandboxes/discord/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
bash "$script_dir"/discord.runner "$@"
