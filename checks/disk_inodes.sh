#!/bin/bash -e

echo "---"
echo "service: disk_inodes"
echo "version: 2014120901"

if [ -z "$1" ]
then
  echo "error: No argument specified."
  exit
fi

echo "argument: $1"

if ! DATA=$(stat --file-system -c "%c %d" "$1" 2>&1)
then
  echo "error: \"$DATA\""
  exit
fi

DATA=( $DATA )

echo "free_inodes: ${DATA[1]}"
echo "total_inodes: ${DATA[0]}"
