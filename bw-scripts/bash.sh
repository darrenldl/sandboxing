#!/usr/bin/env bash

set -euxo pipefail

mkdir -p "$HOME/jails/bash"

bwrap \
  --ro-bind "/" "/" \
  --ro-bind "/usr/bin" "/usr/bin" \
  --tmpfs "/usr/lib/modules" \
  --tmpfs "/usr/lib/systemd" \
  --proc "/proc" \
  --dev "/dev" \
  --tmpfs "/run" \
  --unshare-user \
  --unshare-ipc \
  --tmpfs "/home" \
  --bind "$HOME/jails/bash" "/home/jail" \
  --setenv "HOME" "/home/jail" \
  bash
