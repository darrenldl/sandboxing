#!/bin/bash

mkdir -p ~/jails/bash

bwrap \
  --ro-bind / / \
  --unshare-user \
  --uid $(getent passwd | awk -F: '($3>600) && ($3<10000) && ($3>maxuid) { maxuid=$3; } END { print maxuid+1; }') \
  --gid $(getent passwd | awk -F: '($4>600) && ($4<10000) && ($4>maxgid) { maxgid=$4; } END { print maxgid+1; }') \
  --tmpfs /home \
  --bind ~/jails/bash /home/jail \
  --setenv HOME /home/jail \
  bash
