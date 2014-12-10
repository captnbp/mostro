#!/bin/bash -e

echo "---"
echo "service: disk_inodes"
echo "version: 2014120901"

if [ -z "$1" ]
then
	echo "No argument specified." 1>&2
  exit 1
fi

echo "argument: $1"

DATA=$(stat --file-system -c "%c %d" "$1")
DATA=( $DATA )
echo "free_inodes: ${DATA[1]}"
echo "total_inodes: ${DATA[0]}"
