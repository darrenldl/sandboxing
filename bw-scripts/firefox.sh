#!/bin/bash

mkdir -p ~/jails/firefox

bwrap \
  --ro-bind /usr/share /usr/share \
  --ro-bind /usr/share /usr/share \
  --ro-bind /usr/lib /usr/lib \
  --ro-bind /usr/lib64 /usr/lib64 \
  --symlink /usr/lib /lib \
  --tmpfs /usr/lib/modules \
  --tmpfs /usr/lib/systemd \
  --tmpfs /home \
  --bind ~/jails/firefox /home/jail \
  --setenv HOME /home/jail \
  --bind ~/.mozilla /home/jail/.mozilla \
  --bind ~/.cache/mozilla /home/jail/.cache/mozilla \
  firefox
