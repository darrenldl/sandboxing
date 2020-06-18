#!/usr/bin/env bash

set -euxo pipefail

# if [ ! -f "$(dirname $0)"/../seccomp-bpf/thunderbird.bpf ]; then
  gcc "$(dirname $0)"/../seccomp-bpf/thunderbird.c -lseccomp -o "$(dirname $0)"/../seccomp-bpf/thunderbird.exe
  "$(dirname $0)"/../seccomp-bpf/thunderbird.exe
  mv thunderbird_seccomp_filter.bpf "$(dirname $0)"/../seccomp-bpf
# fi

mkdir -p "$HOME/jails/thunderbird"
mkdir -p "$HOME/jails/thunderbird/Downloads"

bwrap \
  --ro-bind "/usr/share/X11" "/usr/share/X11" \
  --ro-bind "/usr/share/icons" "/usr/share/icons" \
  --ro-bind-try "/usr/share/fontconfig" "/usr/share/fontconfig" \
  --ro-bind "/usr/share/fonts" "/usr/share/fonts" \
  --ro-bind "/usr/share/mime" "/usr/share/mime" \
  --ro-bind "/usr/share/ca-certificates" "/usr/share/ca-certificates" \
  --ro-bind "/usr/share/glib-2.0" "/usr/share/glib-2.0" \
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
  --ro-bind "/run/user/$UID/wayland-0" "/run/user/$UID/wayland-0" \
  --setenv "QT_QPA_PLATFORM" "wayland" \
  --bind "/run/user/$UID/dconf" "/run/user/$UID/dconf" \
  --bind "$HOME/jails/thunderbird" "/home/jail" \
  --setenv "HOME" "/home/jail" \
  --bind "$HOME/.thunderbird" "/home/jail/.thunderbird" \
  --bind "$HOME/.cache/thunderbird" "/home/jail/.cache/thunderbird" \
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
  /usr/lib/thunderbird/thunderbird
