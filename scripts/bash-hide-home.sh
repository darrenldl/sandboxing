#!/usr/bin/bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/bash-hide-home.c -lseccomp -o "$script_dir"/../seccomp-bpf/bash-hide-home.exe
"$script_dir"/../seccomp-bpf/bash-hide-home.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv bash-hide-home_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

gcc "$script_dir"/../runners/bash-hide-home.c -o "$script_dir"/../runners/bash-hide-home.runner

mkdir -p "$HOME/sandboxing-sandboxes/bash-hide-home"
mkdir -p "$HOME/sandboxing-sandboxes/bash-hide-home/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
( exec bwrap \
  --ro-bind "/usr/share" "/usr/share" \
  --ro-bind "/usr/lib" "/usr/lib" \
  --ro-bind "/usr/lib64" "/usr/lib64" \
  --tmpfs "/usr/lib/modules" \
  --tmpfs "/usr/lib/systemd" \
  --symlink "/usr/lib" "/lib" \
  --symlink "/usr/lib64" "/lib64" \
  --ro-bind "/usr/bin" "/usr/bin" \
  --symlink "/usr/bin" "/bin" \
  --symlink "/usr/bin" "/sbin" \
  --ro-bind "/etc/fonts" "/etc/fonts" \
  --ro-bind "/etc/resolv.conf" "/etc/resolv.conf" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/tmp" \
  --tmpfs "/run" \
  --bind "$HOME/sandboxing-sandboxes/bash-hide-home" "/home/sandbox" \
  --setenv "HOME" "/home/sandbox" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --new-session \
  --seccomp 10 10<"$script_dir"/../seccomp-bpf/bash-hide-home_seccomp_filter.bpf \
  --ro-bind ""$script_dir"/../runners/bash-hide-home.runner" "/home/sandbox/bash-hide-home.runner" \
  /home/sandbox/bash-hide-home.runner \
 )
