#!/usr/bin/env bash

set -euxo pipefail

gcc "$(dirname $0)"/../seccomp-bpf/bash-hide-home.c -lseccomp -o "$(dirname $0)"/../seccomp-bpf/bash-hide-home.exe
"$(dirname $0)"/../seccomp-bpf/bash-hide-home.exe
mv bash-hide-home_seccomp_filter.bpf "$(dirname $0)"/../seccomp-bpf

mkdir -p "$HOME/jails/bash-hide-home"
mkdir -p "$HOME/jails/bash-hide-home/Downloads"

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
  --bind "$HOME/jails/bash-hide-home" "/home/jail" \
  --setenv "HOME" "/home/jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --new-session \
  --seccomp 10 10<"$(dirname $0)"/../seccomp-bpf/bash-hide-home_seccomp_filter.bpf \
  /usr/bin/bash )
