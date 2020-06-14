#!/usr/bin/env bash

set -euxo pipefail

mkdir -p ~/jails/thunderbird

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
  --tmpfs /tmp \
  --tmpfs /run \
  --tmpfs /opt \
  --ro-bind /run/user/1000/wayland-0 /run/user/1000/wayland-0 \
  --bind /run/user/1000/dconf /run/user/1000/dconf \
  --tmpfs /home \
  --bind ~/jails/thunderbird /home/jail \
  --setenv HOME /home/jail \
  --bind ~/.thunderbird /home/jail/.thunderbird \
  --bind ~/.cache/thunderbird /home/jail/.cache/thunderbird \
  --chdir /home/jail \
  --unsetenv DBUS_SESSION_BUS_ADDRESS \
  --setenv SHELL /bin/false \
  --setenv USER nobody \
  --setenv LOGNAME nobody \
  --hostname jail \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-cgroup \
  --new-session \
  /usr/lib/thunderbird/thunderbird
