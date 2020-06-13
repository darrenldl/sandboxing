#!/bin/bash

mkdir -p ~/jails/firefox

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
  --tmpfs /home \
  --bind ~/jails/firefox /home/jail \
  --setenv HOME /home/jail \
  --bind ~/.mozilla /home/jail/.mozilla \
  --bind ~/.cache/mozilla /home/jail/.cache/mozilla \
  --chdir /home/jail \
  --unsetenv DBUS_SESSION_BUS_ADDRESS \
  --setenv SHELL /bin/false \
  --setenv USER nobody \
  --setenv LOGNAME nobody \
  --setenv MOZ_ENABLE_WAYLAND 1 \
  --unshare-user \
  --unshare-pid \
  --unshare-uts \
  --unshare-cgroup \
  --new-session \
  /usr/lib/firefox/firefox --ProfileManager
