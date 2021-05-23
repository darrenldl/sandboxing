#!/usr/bin/bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpfs/eom-ro.c -lseccomp -o "$script_dir"/../seccomp-bpfs/eom-ro.exe
"$script_dir"/../seccomp-bpfs/eom-ro.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv eom-ro_seccomp_filter.bpf "$script_dir"/../seccomp-bpfs

gcc "$script_dir"/../runners/eom-ro.c -o "$script_dir"/../runners/eom-ro.runner

cur_time=$(date "+%Y-%m-%d_%H%M%S")
mkdir -p "$HOME/sandbox-logs/eom-ro"
stdout_log_name="$HOME/sandbox-logs/eom-ro"/"$cur_time"."stdout"

mkdir -p "$HOME/sandbox-logs/eom-ro"
stderr_log_name="$HOME/sandbox-logs/eom-ro"/"$cur_time"."stderr"


( exec bwrap \
  --ro-bind "/usr/share" "/usr/share" \
  --ro-bind "/usr/lib" "/usr/lib" \
  --ro-bind "/usr/lib64" "/usr/lib64" \
  --tmpfs "/usr/lib/modules" \
  --tmpfs "/usr/lib/systemd" \
  --symlink "/usr/lib" "/lib" \
  --symlink "/usr/lib64" "/lib64" \
  --ro-bind "/usr/bin/eom" "/usr/bin/eom" \
  --ro-bind "/usr/bin/eom" "/bin/eom" \
  --ro-bind "/usr/bin/eom" "/sbin/eom" \
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
  --ro-bind "$1" "/home/sandbox/$(basename "$1")" \
  --hostname "jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --unshare-net \
  --new-session \
  --seccomp 10 10<"$script_dir"/../seccomp-bpfs/eom-ro_seccomp_filter.bpf \
  --ro-bind ""$script_dir"/../runners/eom-ro.runner" "/home/sandbox/eom-ro.runner" \
  /home/sandbox/eom-ro.runner "/home/sandbox/$(basename "$1")" \
  >$stdout_log_name \
  2>$stderr_log_name \
 )
