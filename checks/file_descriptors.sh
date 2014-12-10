#!/bin/bash -e

echo "---"
echo "service: file_descriptors"
echo "version: 2014120901"

DATA=$(</proc/sys/fs/file-nr)

DATA=( $DATA )
echo "count: ${DATA[0]}"
echo "total: ${DATA[2]}"
