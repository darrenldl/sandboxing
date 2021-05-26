#!/usr/bin/bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpfs/firefox-tmp.c -lseccomp -o "$script_dir"/../seccomp-bpfs/firefox-tmp.exe
"$script_dir"/../seccomp-bpfs/firefox-tmp.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv firefox-tmp_seccomp_filter.bpf "$script_dir"/../seccomp-bpfs

gcc "$script_dir"/../runners/firefox-tmp.c -o "$script_dir"/../runners/firefox-tmp.runner

cur_time=$(date "+%Y-%m-%d_%H%M%S")
mkdir -p "$HOME/sandbox-logs/firefox-tmp"
stdout_log_name="$HOME/sandbox-logs/firefox-tmp"/"$cur_time"."stdout"

mkdir -p "$HOME/sandbox-logs/firefox-tmp"
stderr_log_name="$HOME/sandbox-logs/firefox-tmp"/"$cur_time"."stderr"

tmp_dir=$(mktemp -d -t firefox-tmp-$cur_time-XXXX)
mkdir -p "$tmp_dir/Downloads"


( exec bwrap \
  --ro-bind "/usr/share" "/usr/share" \
  --ro-bind "/usr/lib" "/usr/lib" \
  --ro-bind "/usr/lib64" "/usr/lib64" \
  --tmpfs "/usr/lib/modules" \
  --tmpfs "/usr/lib/systemd" \
  --symlink "/usr/lib" "/lib" \
  --symlink "/usr/lib64" "/lib64" \
  --ro-bind "/usr/bin/firefox" "/usr/bin/firefox" \
  --ro-bind "/usr/bin/firefox" "/bin/firefox" \
  --ro-bind "/usr/bin/firefox" "/sbin/firefox" \
  --ro-bind "/etc/fonts" "/etc/fonts" \
  --ro-bind "/etc/resolv.conf" "/etc/resolv.conf" \
  --ro-bind "/etc/ssl" "/etc/ssl" \
  --ro-bind "/etc/ca-certificates" "/etc/ca-certificates" \
  --ro-bind "/etc/localtime" "/etc/localtime" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/tmp" \
  --tmpfs "/run" \
  --ro-bind-try "/usr/share/gst-plugins-bad" "/usr/share/gst-plugins-bad" \
  --ro-bind-try "/usr/share/gst-plugins-base" "/usr/share/gst-plugins-base" \
  --ro-bind-try "/usr/share/gstreamer-1.0" "/usr/share/gstreamer-1.0" \
  --ro-bind "/run/user/$UID/pulse" "/run/user/$UID/pulse" \
  --ro-bind-try "/run/user/$UID/wayland-0" "/run/user/$UID/wayland-0" \
  --ro-bind-try "/run/user/$UID/wayland-1" "/run/user/$UID/wayland-1" \
  --ro-bind-try "/run/user/$UID/wayland-2" "/run/user/$UID/wayland-2" \
  --ro-bind-try "/run/user/$UID/wayland-3" "/run/user/$UID/wayland-3" \
  --setenv "QT_QPA_PLATFORM" "wayland" \
  --bind "/run/user/$UID/dconf" "/run/user/$UID/dconf" \
  --ro-bind "/run/user/$UID/bus" "/run/user/$UID/bus" \
  --tmpfs "/home/sandbox" \
  --setenv "HOME" "/home/sandbox" \
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
  --bind "$tmp_dir/Downloads" "/home/sandbox/Downloads" \
  --seccomp 10 10<"$script_dir"/../seccomp-bpfs/firefox-tmp_seccomp_filter.bpf \
  --ro-bind ""$script_dir"/../runners/firefox-tmp.runner" "/home/sandbox/firefox-tmp.runner" \
  /home/sandbox/firefox-tmp.runner --no-remote \
  >$stdout_log_name \
  2>$stderr_log_name \
 )

rmdir --ignore-fail-on-non-empty "$tmp_dir/Downloads"
rmdir --ignore-fail-on-non-empty "$tmp_dir"
