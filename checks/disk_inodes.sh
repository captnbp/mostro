#!/bin/bash -e

echo "---"
echo "service: disk_inodes"

if [ -z "$1" ]
then
  echo "error: No argument specified."
  exit 254
fi

echo "argument: $1"

if ! DATA=$(stat --file-system -c "%c %d" "$1" 2>&1)
then
  echo "error: \"$DATA\""
  exit 254
fi

DATA=( $DATA )

if [[ "${DATA[0]}" = "0" ]]
then
  echo "error: The filesystem doesn't use inodes."
  exit 254
fi

echo "free_inodes: ${DATA[1]}"
echo "total_inodes: ${DATA[0]}"
