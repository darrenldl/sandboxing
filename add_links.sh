#!/bin/bash

prefix="sand"

dst=$1

if [[ "$dst" == "" ]]; then
  echo "Please specify destination"
  exit 1
fi

for file in bw-scripts/*.sh; do
  name=$(basename $file | sed 's/\.sh//g')

  echo "Creating symbolic link for" $name

  ln -s $(realpath "$file") "$dst"/"$prefix"-"$name"
done
