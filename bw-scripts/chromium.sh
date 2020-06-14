#!/usr/bin/env bash

set -euxo pipefail

mkdir -p ~/jails/chromium

bwrap \
  --ro-bind /usr/bin /usr/bin \
  --ro-bind /usr/share /usr/share \
  --ro-bind /usr/lib /usr/lib \
  --ro-bind /usr/lib64 /usr/lib64 \
  --symlink /usr/lib /lib \
  --symlink /usr/lib64 /lib64 \
  --symlink /usr/bin /bin \
  --symlink /usr/bin /sbin \
  --ro-bind /etc /etc \
  --tmpfs /usr/lib/modules \
  --tmpfs /usr/lib/systemd \
  --proc /proc \
  --dev /dev \
  --dev-bind /dev/dri/card0 /dev/dri/card0 \
  --dev-bind /dev/snd /dev/snd \
  --tmpfs /tmp \
  --tmpfs /run \
  --ro-bind /run/user/1000/bus /run/user/1000/bus \
  --ro-bind /run/user/1000/pulse /run/user/1000/pulse \
  --bind /run/user/1000/dconf /run/user/1000/dconf \
  --tmpfs /home \
  --bind ~/jails/chromium /home/jail \
  --setenv HOME /home/jail \
  --chdir /home/jail \
  --unsetenv DBUS_SESSION_BUS_ADDRESS \
  --setenv SHELL /bin/false \
  --setenv USER nobody \
  --setenv LOGNAME nobody \
  --hostname jail \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-ipc \
  --unshare-cgroup \
  --new-session \
  /usr/lib/chromium/chromium
