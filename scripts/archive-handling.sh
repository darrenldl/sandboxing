#!/usr/bin/bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpf/archive-handling.c -lseccomp -o "$script_dir"/../seccomp-bpf/archive-handling.exe
"$script_dir"/../seccomp-bpf/archive-handling.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv archive-handling_seccomp_filter.bpf "$script_dir"/../seccomp-bpf

gcc "$script_dir"/../runners/archive-handling.c -o "$script_dir"/../runners/archive-handling.runner

mkdir -p "$HOME/sandboxing-sandboxes/archive-handling"
mkdir -p "$HOME/sandboxing-sandboxes/archive-handling/Downloads"

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
  --ro-bind "/etc/ssl" "/etc/ssl" \
  --ro-bind "/etc/localtime" "/etc/localtime" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/tmp" \
  --tmpfs "/run" \
  --ro-bind "/run/user/$UID/wayland-0" "/run/user/$UID/wayland-0" \
  --setenv "QT_QPA_PLATFORM" "wayland" \
  --tmpfs "/home/sandbox" \
  --setenv "HOME" "/home/sandbox" \
  --unsetenv "DBUS_SESSION_BUS_ADDRESS" \
  --setenv "SHELL" "/bin/false" \
  --setenv "USER" "nobody" \
  --setenv "LOGNAME" "nobody" \
  --hostname "jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --unshare-net \
  --new-session \
  --seccomp 10 10<"$script_dir"/../seccomp-bpf/archive-handling_seccomp_filter.bpf \
  --ro-bind ""$script_dir"/../runners/archive-handling.runner" "/home/sandbox/archive-handling.runner" \
  /home/sandbox/archive-handling.runner \
 )
