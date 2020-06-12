#!/bin/bash

mkdir -p ~/jails/bash

bwrap \
  --ro-bind / / \
  --bind ~/jails/bash ~ \
  bash
