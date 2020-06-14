#!/usr/bin/env bash

set -euxo pipefail

mkdir -p "$HOME/jails/firefox"

bwrap \
  --ro-bind "/usr/share/X11" "/usr/share/X11" \
  --ro-bind "/usr/share/icons" "/usr/share/icons" \
  --ro-bind "/usr/share/fonts" "/usr/share/fonts" \
  --ro-bind "/usr/share/mime" "/usr/share/mime" \
  --ro-bind "/usr/share/ca-certificates" "/usr/share/ca-certificates" \
  --ro-bind "/usr/lib" "/usr/lib" \
  --ro-bind "/usr/lib64" "/usr/lib64" \
  --tmpfs "/usr/lib/modules" \
  --tmpfs "/usr/lib/systemd" \
  --symlink "/usr/lib" "/lib" \
  --symlink "/usr/lib64" "/lib64" \
  --symlink "/usr/bin" "/bin" \
  --symlink "/usr/bin" "/sbin" \
  --ro-bind "/etc/fonts" "/etc/fonts" \
  --ro-bind "/etc/machine-id" "/etc/machine-id" \
  --ro-bind "/etc/resolv.conf" "/etc/resolv.conf" \
  --proc "/proc" \
  --dev "/dev" \
  --dev-bind "/dev/snd" "/dev/snd" \
  --ro-bind "/run/user/1000/bus" "/run/user/1000/bus" \
  --ro-bind "/run/user/1000/pulse" "/run/user/1000/pulse" \
  --ro-bind "/run/user/1000/wayland-0" "/run/user/1000/wayland-0" \
  --bind "/run/user/1000/dconf" "/run/user/1000/dconf" \
  --tmpfs "/home" \
  --bind "$HOME/jails/firefox" "/home/jail" \
  --setenv "HOME" "/home/jail" \
  --bind "$HOME/.mozilla" "/home/jail/.mozilla" \
  --bind "$HOME/.cache/mozilla" "/home/jail/.cache/mozilla" \
  --chdir "/home/jail" \
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
  /usr/lib/firefox/firefox --ProfileManager
