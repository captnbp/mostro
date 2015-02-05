#!/bin/bash -e

echo "---"
echo "service: file_descriptors"
echo "version: 2014120901"

if ! DATA=$(cat /proc/sys/fs/file-nr 2>&1)
then
  echo "error: \"$DATA\""
  exit 254
fi

DATA=( $DATA )

echo "count: ${DATA[0]}"
echo "total: ${DATA[2]}"
