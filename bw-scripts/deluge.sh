#!/usr/bin/env bash

set -euxo pipefail

gcc "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/deluge.c -lseccomp -o "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/deluge.exe
"$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/deluge.exe
mv deluge_seccomp_filter.bpf "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf

mkdir -p "$HOME/jails/deluge"
mkdir -p "$HOME/jails/deluge/Downloads"

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
  --ro-bind "/etc/ssl" "/etc/ssl" \
  --ro-bind "/etc/localtime" "/etc/localtime" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/tmp" \
  --tmpfs "/run" \
  --ro-bind "/run/user/$UID/wayland-0" "/run/user/$UID/wayland-0" \
  --setenv "QT_QPA_PLATFORM" "wayland" \
  --bind "/run/user/$UID/dconf" "/run/user/$UID/dconf" \
  --ro-bind "/run/user/$UID/bus" "/run/user/$UID/bus" \
  --ro-bind "/etc/lsb-release" "/etc/lsb-release" \
  --ro-bind "/etc/arch-release" "/etc/arch-release" \
  --bind "$HOME/jails/deluge" "/home/jail" \
  --setenv "HOME" "/home/jail" \
  --unsetenv "DBUS_SESSION_BUS_ADDRESS" \
  --setenv "SHELL" "/bin/false" \
  --setenv "USER" "nobody" \
  --setenv "LOGNAME" "nobody" \
  --setenv "MOZ_ENABLE_WAYLAND" "1" \
  --hostname "jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --new-session \
  --seccomp 10 10<"$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/deluge_seccomp_filter.bpf \
  /usr/bin/deluge )
