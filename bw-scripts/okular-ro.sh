#!/usr/bin/env bash

set -euxo pipefail

gcc "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/okular-ro.c -lseccomp -o "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/okular-ro.exe
"$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/okular-ro.exe
mv okular-ro_seccomp_filter.bpf "$(dirname "$(readlink -f "$0")")"/../seccomp-bpf

cur_time=$(date "+%Y-%m-%d_%H%M%S")
mkdir -p "$HOME/jail-logs/okular-ro"
stdout_log_name="$HOME/jail-logs/okular-ro"/"$cur_time"."stdout"

mkdir -p "$HOME/jail-logs/okular-ro"
stderr_log_name="$HOME/jail-logs/okular-ro"/"$cur_time"."stderr"

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
  --tmpfs "/home/jail" \
  --setenv "HOME" "/home/jail" \
  --unsetenv "DBUS_SESSION_BUS_ADDRESS" \
  --setenv "SHELL" "/bin/false" \
  --setenv "USER" "nobody" \
  --setenv "LOGNAME" "nobody" \
  --ro-bind "$1" "/home/jail/$(basename $1)" \
  --hostname "jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --unshare-net \
  --new-session \
  --seccomp 10 10<"$(dirname "$(readlink -f "$0")")"/../seccomp-bpf/okular-ro_seccomp_filter.bpf \
  /usr/bin/okular /home/jail/$(basename $1) >$stdout_log_name 2>$stderr_log_name )
