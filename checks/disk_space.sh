#!/bin/bash -e

echo "---"
echo "service: disk_space"

if [ -z "$1" ]
then
  echo "error: No argument specified."
  exit 254
fi

echo "argument: $1"

if ! DATA=$(stat --file-system -c "%s %a %b" "$1" 2>&1)
then
  echo "error: \"$DATA\""
  exit 254
fi

DATA=( $DATA )

echo "block_size: ${DATA[0]}"
echo "free_blocks: ${DATA[1]}"
echo "total_blocks: ${DATA[2]}"

