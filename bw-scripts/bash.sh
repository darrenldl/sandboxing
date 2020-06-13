#!/usr/bin/env bash

set -euxo pipefail

mkdir -p ~/jails/bash

bwrap \
  --ro-bind / / \
  --ro-bind /usr/bin /usr/bin \
  --tmpfs /usr/lib/modules \
  --tmpfs /usr/lib/systemd \
  --proc /proc \
  --dev /dev \
  --tmpfs /run \
  --unshare-user \
  --tmpfs /home \
  --bind ~/jails/bash /home/jail \
  --setenv HOME /home/jail \
  bash
