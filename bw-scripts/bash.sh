#!/bin/bash

bwrap \
  --ro-bind '/' '/' \
  bash
