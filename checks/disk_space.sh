#!/bin/bash -e

echo "---"
echo "service: disk_space"
echo "version: 2014120901"

if [ -z "$1" ]
then
  echo "No argument specified." 1>&2
  exit 1
fi

echo "argument: $1"

DATA=$(stat --file-system -c "%s %a %b" "$1")

DATA=( $DATA )

echo "block_size: ${DATA[0]}"
echo "free_blocks: ${DATA[1]}"
echo "total_blocks: ${DATA[2]}"
