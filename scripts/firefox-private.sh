#!/usr/bin/bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpfs/firefox-private.c -lseccomp -o "$script_dir"/../seccomp-bpfs/firefox-private.exe
"$script_dir"/../seccomp-bpfs/firefox-private.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv firefox-private_seccomp_filter.bpf "$script_dir"/../seccomp-bpfs

gcc "$script_dir"/../runners/firefox-private.c -o "$script_dir"/../runners/firefox-private.runner

cur_time=$(date "+%Y-%m-%d_%H%M%S")
mkdir -p "$HOME/sandbox-logs/firefox-private"
stdout_log_name="$HOME/sandbox-logs/firefox-private"/"$cur_time"."stdout"

mkdir -p "$HOME/sandbox-logs/firefox-private"
stderr_log_name="$HOME/sandbox-logs/firefox-private"/"$cur_time"."stderr"

tmp_dir=$(mktemp -d -t firefox-private-$cur_time-XXXX)
mkdir -p "$tmp_dir/Downloads"

shopt -s nullglob
glob_list_33=(/etc/firefox/*)
shopt -u nullglob
expanding_arg_33=""
for x in ${glob_list_33[@]}; do
  if [[ $x != "" ]]; then
    expanding_arg_33+=" --ro-bind "$x" "$x" "
  fi
done
shopt -s nullglob
glob_list_36=(/etc/firefox/*)
shopt -u nullglob
expanding_arg_36=""
for x in ${glob_list_36[@]}; do
  if [[ $x != "" ]]; then
    expanding_arg_36+=" --ro-bind "$x" "$x" "
  fi
done
shopt -s nullglob
glob_list_39=(/etc/firefox-esr/*)
shopt -u nullglob
expanding_arg_39=""
for x in ${glob_list_39[@]}; do
  if [[ $x != "" ]]; then
    expanding_arg_39+=" --ro-bind "$x" "$x" "
  fi
done
shopt -s nullglob
glob_list_42=(/usr/lib/firefox/*)
shopt -u nullglob
expanding_arg_42=""
for x in ${glob_list_42[@]}; do
  if [[ $x != "" ]]; then
    expanding_arg_42+=" --ro-bind "$x" "$x" "
  fi
done
shopt -s nullglob
glob_list_47=(/usr/lib32/firefox/*)
shopt -u nullglob
expanding_arg_47=""
for x in ${glob_list_47[@]}; do
  if [[ $x != "" ]]; then
    expanding_arg_47+=" --ro-bind "$x" "$x" "
  fi
done
shopt -s nullglob
glob_list_52=(/usr/lib64/firefox/*)
shopt -u nullglob
expanding_arg_52=""
for x in ${glob_list_52[@]}; do
  if [[ $x != "" ]]; then
    expanding_arg_52+=" --ro-bind "$x" "$x" "
  fi
done

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
  --tmpfs "/etc/firefox" \
  $expanding_arg_33 \
  --ro-bind "$script_dir/../firefox-hardening/systemwide_user.js" "/etc/firefox/syspref.js" \
  --tmpfs "/etc/firefox" \
  $expanding_arg_36 \
  --ro-bind "$script_dir/../firefox-hardening/systemwide_user.js" "/etc/firefox/firefox.js" \
  --tmpfs "/etc/firefox-esr" \
  $expanding_arg_39 \
  --ro-bind "$script_dir/../firefox-hardening/systemwide_user.js" "/etc/firefox-esr/firefox-esr.js" \
  --tmpfs "/usr/lib/firefox/" \
  $expanding_arg_42 \
  --ro-bind "$script_dir/../firefox-hardening/systemwide_user.js" "/usr/lib/firefox/mozilla.cfg" \
  --tmpfs "/usr/lib/firefox/defaults/pref/" \
  --ro-bind "$script_dir/../firefox-hardening/local-settings.js" "/usr/lib/firefox/defaults/pref/local-settings.js" \
  --tmpfs "/usr/lib32/firefox/" \
  $expanding_arg_47 \
  --ro-bind "$script_dir/../firefox-hardening/systemwide_user.js" "/usr/lib32/firefox/mozilla.cfg" \
  --tmpfs "/usr/lib32/firefox/defaults/pref/" \
  --ro-bind "$script_dir/../firefox-hardening/local-settings.js" "/usr/lib32/firefox/defaults/pref/local-settings.js" \
  --tmpfs "/usr/lib64/firefox/" \
  $expanding_arg_52 \
  --ro-bind "$script_dir/../firefox-hardening/systemwide_user.js" "/usr/lib64/firefox/mozilla.cfg" \
  --tmpfs "/usr/lib64/firefox/defaults/pref/" \
  --ro-bind "$script_dir/../firefox-hardening/local-settings.js" "/usr/lib64/firefox/defaults/pref/local-settings.js" \
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
  --seccomp 10 10<"$script_dir"/../seccomp-bpfs/firefox-private_seccomp_filter.bpf \
  --ro-bind ""$script_dir"/../runners/firefox-private.runner" "/home/sandbox/firefox-private.runner" \
  /home/sandbox/firefox-private.runner --no-remote \
  >$stdout_log_name \
  2>$stderr_log_name \
 )

rmdir --ignore-fail-on-non-empty "$tmp_dir/Downloads"
rmdir --ignore-fail-on-non-empty "$tmp_dir"
