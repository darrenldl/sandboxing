#!/usr/bin/bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpfs/make-workspace.c -lseccomp -o "$script_dir"/../seccomp-bpfs/make-workspace.exe
"$script_dir"/../seccomp-bpfs/make-workspace.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv make-workspace_seccomp_filter.bpf "$script_dir"/../seccomp-bpfs

gcc "$script_dir"/../runners/make-workspace.c -o "$script_dir"/../runners/make-workspace.runner

mkdir -p "$HOME/sandboxing-sandboxes/make-workspace-$1"
mkdir -p "$HOME/sandboxing-sandboxes/make-workspace-$1/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")

ulimit -u 500

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
  --setenv "PATH" "/usr/bin" \
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
  --bind "$HOME/sandboxing-sandboxes/make-workspace-$1" "/home/sandbox" \
  --setenv "HOME" "/home/sandbox" \
  --unsetenv "DBUS_SESSION_BUS_ADDRESS" \
  --setenv "USER" "nobody" \
  --setenv "LOGNAME" "nobody" \
  --hostname "jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --new-session \
  --seccomp 10 10<"$script_dir"/../seccomp-bpfs/make-workspace_seccomp_filter.bpf \
  --ro-bind ""$script_dir"/../runners/make-workspace.runner" "/home/sandbox/make-workspace.runner" \
  /home/sandbox/make-workspace.runner \
 )
