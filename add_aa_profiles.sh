#!/bin/bash

script_dir=$(dirname $(readlink -f "$0"))

if [[ "$dst" == "" ]]; then
  echo "Please specify destination"
  exit 1
fi

for file in "$script_dir"/aa-profiles/*; do
  cp $(realpath "$file") "$dst_file"
done
