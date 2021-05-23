#!/usr/bin/bash

set -euxo pipefail

script_dir=$(dirname $(readlink -f "$0"))

gcc "$script_dir"/../seccomp-bpfs/bash.c -lseccomp -o "$script_dir"/../seccomp-bpfs/bash.exe
"$script_dir"/../seccomp-bpfs/bash.exe
if [[ $? != 0 ]]; then
  echo "Failed to generate seccomp filter"
  exit 1
fi

mv bash_seccomp_filter.bpf "$script_dir"/../seccomp-bpfs

gcc "$script_dir"/../runners/bash.c -o "$script_dir"/../runners/bash.runner

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
  --setenv "PATH" "/usr/bin" \
  --ro-bind "/etc/fonts" "/etc/fonts" \
  --ro-bind "/etc/resolv.conf" "/etc/resolv.conf" \
  --ro-bind "/etc/ssl" "/etc/ssl" \
  --ro-bind "/etc/localtime" "/etc/localtime" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/tmp" \
  --tmpfs "/run" \
  --unsetenv "DBUS_SESSION_BUS_ADDRESS" \
  --setenv "HOME" "/home/sandbox" \
  --setenv "USER" "sandbox" \
  --setenv "LOGNAME" "sandbox" \
  --bind "." "/home/sandbox/workspace" \
  --hostname "jail" \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --seccomp 10 10<"$script_dir"/../seccomp-bpfs/bash_seccomp_filter.bpf \
  --ro-bind ""$script_dir"/../runners/bash.runner" "/home/sandbox/bash.runner" \
  /home/sandbox/bash.runner \
 )
