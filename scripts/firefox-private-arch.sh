#!/usr/bin/bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpfs/firefox-private-arch.c -lseccomp -o "$script_dir"/../seccomp-bpfs/firefox-private-arch.exe
"$script_dir"/../seccomp-bpfs/firefox-private-arch.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv firefox-private-arch_seccomp_filter.bpf "$script_dir"/../seccomp-bpfs

gcc "$script_dir"/../runners/firefox-private-arch.c -o "$script_dir"/../runners/firefox-private-arch.runner

cur_time=$(date "+%Y-%m-%d_%H%M%S")
mkdir -p "$HOME/sandboxing-sandbox-logs/firefox-private-arch"
stdout_log_name="$HOME/sandboxing-sandbox-logs/firefox-private-arch"/"$cur_time"."stdout"

mkdir -p "$HOME/sandboxing-sandbox-logs/firefox-private-arch"
stderr_log_name="$HOME/sandboxing-sandbox-logs/firefox-private-arch"/"$cur_time"."stderr"

tmp_dir=$(mktemp -d -t firefox-private-arch-$cur_time-XXXX)
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
  --ro-bind "/etc/localtime" "/etc/localtime" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/tmp" \
  --tmpfs "/run" \
  --ro-bind-try "/usr/share/gst-plugins-bad" "/usr/share/gst-plugins-bad" \
  --ro-bind-try "/usr/share/gst-plugins-base" "/usr/share/gst-plugins-base" \
  --ro-bind-try "/usr/share/gstreamer-1.0" "/usr/share/gstreamer-1.0" \
  --ro-bind "/run/user/$UID/pulse" "/run/user/$UID/pulse" \
  --ro-bind "/run/user/$UID/wayland-0" "/run/user/$UID/wayland-0" \
  --setenv "QT_QPA_PLATFORM" "wayland" \
  --bind "/run/user/$UID/dconf" "/run/user/$UID/dconf" \
  --ro-bind "/run/user/$UID/bus" "/run/user/$UID/bus" \
  --tmpfs "/home/sandbox" \
  --setenv "HOME" "/home/sandbox" \
  --tmpfs "/usr/lib/firefox/" \
  --ro-bind "$script_dir/../firefox-hardening/systemwide_user.js" "/usr/lib/firefox/mozilla.cfg" \
  --ro-bind "/usr/lib/firefox/dependentlibs.list" "/usr/lib/firefox/dependentlibs.list" \
  --ro-bind "/usr/lib/firefox/pingsender" "/usr/lib/firefox/pingsender" \
  --ro-bind "/usr/lib/firefox/browser" "/usr/lib/firefox/browser" \
  --ro-bind "/usr/lib/firefox/libmozsandbox.so" "/usr/lib/firefox/libmozsandbox.so" \
  --ro-bind "/usr/lib/firefox/libmozgtk.so" "/usr/lib/firefox/libmozgtk.so" \
  --ro-bind "/usr/lib/firefox/removed-files" "/usr/lib/firefox/removed-files" \
  --ro-bind "/usr/lib/firefox/firefox" "/usr/lib/firefox/firefox" \
  --ro-bind "/usr/lib/firefox/liblgpllibs.so" "/usr/lib/firefox/liblgpllibs.so" \
  --ro-bind "/usr/lib/firefox/Throbber-small.gif" "/usr/lib/firefox/Throbber-small.gif" \
  --ro-bind "/usr/lib/firefox/fonts" "/usr/lib/firefox/fonts" \
  --ro-bind "/usr/lib/firefox/minidump-analyzer" "/usr/lib/firefox/minidump-analyzer" \
  --ro-bind "/usr/lib/firefox/platform.ini" "/usr/lib/firefox/platform.ini" \
  --ro-bind "/usr/lib/firefox/application.ini" "/usr/lib/firefox/application.ini" \
  --ro-bind "/usr/lib/firefox/libmozavutil.so" "/usr/lib/firefox/libmozavutil.so" \
  --ro-bind "/usr/lib/firefox/libmozwayland.so" "/usr/lib/firefox/libmozwayland.so" \
  --ro-bind "/usr/lib/firefox/distribution" "/usr/lib/firefox/distribution" \
  --ro-bind "/usr/lib/firefox/firefox-bin" "/usr/lib/firefox/firefox-bin" \
  --ro-bind "/usr/lib/firefox/libmozsqlite3.so" "/usr/lib/firefox/libmozsqlite3.so" \
  --ro-bind "/usr/lib/firefox/plugin-container" "/usr/lib/firefox/plugin-container" \
  --ro-bind "/usr/lib/firefox/crashreporter.ini" "/usr/lib/firefox/crashreporter.ini" \
  --ro-bind "/usr/lib/firefox/crashreporter" "/usr/lib/firefox/crashreporter" \
  --ro-bind "/usr/lib/firefox/libxul.so" "/usr/lib/firefox/libxul.so" \
  --ro-bind "/usr/lib/firefox/defaults" "/usr/lib/firefox/defaults" \
  --ro-bind "/usr/lib/firefox/libmozavcodec.so" "/usr/lib/firefox/libmozavcodec.so" \
  --ro-bind "/usr/lib/firefox/omni.ja" "/usr/lib/firefox/omni.ja" \
  --ro-bind "/usr/lib/firefox/gmp-clearkey" "/usr/lib/firefox/gmp-clearkey" \
  --ro-bind "/usr/lib/firefox/gtk2" "/usr/lib/firefox/gtk2" \
  --tmpfs "/usr/lib/firefox/defaults/pref/" \
  --ro-bind "$script_dir/../firefox-hardening/local-settings.js" "/usr/lib/firefox/defaults/pref/local-settings.js" \
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
  --seccomp 10 10<"$script_dir"/../seccomp-bpfs/firefox-private-arch_seccomp_filter.bpf \
  --ro-bind ""$script_dir"/../runners/firefox-private-arch.runner" "/home/sandbox/firefox-private-arch.runner" \
  /home/sandbox/firefox-private-arch.runner --no-remote\
  >$stdout_log_name \
  2>$stderr_log_name \
 )

rmdir --ignore-fail-on-non-empty "$tmp_dir/Downloads"
rmdir --ignore-fail-on-non-empty "$tmp_dir"
