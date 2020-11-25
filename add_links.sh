#!/bin/bash

prefix="sandbox"

dst=$1

script_dir=$(dirname $(readlink -f "$0"))

if [[ "$dst" == "" ]]; then
  echo "Please specify destination"
  exit 1
fi

for file in "$script_dir"/scripts/*.sh; do
  name=$(basename $file | sed 's/\.sh//g')

  echo "Creating symbolic link for" $name

  dst_file="$dst"/"$prefix"-"$name"

  rm -f "$dst_file"
  ln -s $(realpath "$file") "$dst_file"
done
