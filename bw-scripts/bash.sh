#!/usr/bin/env bash

set -euxo pipefail

gcc "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/bash.c -lseccomp -o "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/bash.exe
"$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/bash.exe
mv bash_seccomp_filter.bpf "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf

mkdir -p "$HOME/jails/bash"
mkdir -p "$HOME/jails/bash/Downloads"

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
  --ro-bind "/etc/machine-id" "/etc/machine-id" \
  --ro-bind "/etc/resolv.conf" "/etc/resolv.conf" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/tmp" \
  --tmpfs "/run" \
  --bind "$HOME/jails/bash" "/home/jail" \
  --setenv "HOME" "/home/jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --new-session \
  --seccomp 10 10<"$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/bash_seccomp_filter.bpf \
  /usr/bin/bash )
