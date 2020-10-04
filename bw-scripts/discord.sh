#!/usr/bin/env bash

set -euxo pipefail

gcc "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/discord.c -lseccomp -o "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/discord.exe
"$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/discord.exe
mv discord_seccomp_filter.bpf "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf

mkdir -p "$HOME/jails/discord"
mkdir -p "$HOME/jails/discord/Downloads"

cur_time=$(date "+%Y-%m-%d_%H%M%S")
( exec bwrap \
  --ro-bind "/usr/share" "/usr/share" \
  --ro-bind "/usr/lib" "/usr/lib" \
  --ro-bind "/usr/lib64" "/usr/lib64" \
  --tmpfs "/usr/lib/modules" \
  --tmpfs "/usr/lib/systemd" \
  --symlink "/usr/lib" "/lib" \
  --symlink "/usr/lib64" "/lib64" \
  --ro-bind "/usr/bin/discord" "/usr/bin/discord" \
  --ro-bind "/usr/bin/discord" "/bin/discord" \
  --ro-bind "/usr/bin/discord" "/sbin/discord" \
  --ro-bind "/usr/bin/firefox" "/usr/bin/firefox" \
  --ro-bind "/usr/bin/firefox" "/bin/firefox" \
  --ro-bind "/usr/bin/firefox" "/sbin/firefox" \
  --ro-bind "/etc/fonts" "/etc/fonts" \
  --ro-bind "/etc/machine-id" "/etc/machine-id" \
  --ro-bind "/etc/resolv.conf" "/etc/resolv.conf" \
  --ro-bind "/etc/ssl" "/etc/ssl" \
  --ro-bind "/etc/localtime" "/etc/localtime" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/tmp" \
  --tmpfs "/run" \
  --ro-bind-try "/usr/share/gst-plugins-bad" "/usr/share/gst-plugins-bad" \
  --ro-bind-try "/usr/share/gst-plugins-base" "/usr/share/gst-plugins-base" \
  --ro-bind-try "/usr/share/gstreamer-1.0" "/usr/share/gstreamer-1.0" \
  --ro-bind "/run/user/$UID/pulse" "/run/user/$UID/pulse" \
  --ro-bind "/tmp/.X11-unix" "/tmp/.X11-unix" \
  --bind "/run/user/$UID/dconf" "/run/user/$UID/dconf" \
  --ro-bind "/run/user/$UID/bus" "/run/user/$UID/bus" \
  --ro-bind "/opt/discord" "/opt/discord" \
  --bind "$HOME/jails/discord" "/home/jail" \
  --setenv "HOME" "/home/jail" \
  --unsetenv "DBUS_SESSION_BUS_ADDRESS" \
  --setenv "QT_X11_NO_MITSHM" "1" \
  --setenv "_X11_NO_MITSHM" "1" \
  --setenv "_MITSHM" "0" \
  --setenv "SHELL" "/bin/false" \
  --setenv "USER" "nobody" \
  --setenv "LOGNAME" "nobody" \
  --hostname "jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-cgroup \
  --new-session \
  --seccomp 10 10<"$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/discord_seccomp_filter.bpf \
  /usr/bin/discord )
