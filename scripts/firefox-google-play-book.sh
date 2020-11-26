#!/usr/bin/env bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/firefox-google-play-book.c -lseccomp -o "$script_dir"/../seccomp-bpf/firefox-google-play-book.exe
"$script_dir"/../seccomp-bpf/firefox-google-play-book.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv firefox-google-play-book_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

mkdir -p "$HOME/sandboxes/firefox-google-play-book"
mkdir -p "$HOME/sandboxes/firefox-google-play-book/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
export script_dir
export tmp_dir
export stdout_log_name
export stderr_log_name
"$script_dir"/firefox-google-play-book.runner "$@"
