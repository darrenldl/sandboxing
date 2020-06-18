#!/usr/bin/env bash

set -euxo pipefail

# if [ ! -f "$(dirname $0)"/../seccomp-bpf/bash.bpf ]; then
  gcc "$(dirname $0)"/../seccomp-bpf/bash.c -lseccomp -o "$(dirname $0)"/../seccomp-bpf/bash.exe
  "$(dirname $0)"/../seccomp-bpf/bash.exe
  mv bash_seccomp_filter.bpf "$(dirname $0)"/../seccomp-bpf
# fi

mkdir -p "$HOME/jails/bash"
mkdir -p "$HOME/jails/bash/Downloads"

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
  --ro-bind "/etc/lsb-release" "/etc/lsb-release" \
  --ro-bind "/etc/arch-release" "/etc/arch-release" \
  --ro-bind "/usr/bin" "/usr/bin" \
  --unshare-user \
  --unshare-ipc \
  --bind "$HOME/jails/bash" "/home/jail" \
  --setenv "HOME" "/home/jail" \
  --seccomp 10 10<"$(dirname $0)"/../seccomp-bpf/bash_seccomp_filter.bpf \
  bash
