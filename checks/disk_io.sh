#!/bin/bash -e

echo "---"
echo "service: disk_io"

if [ -z "$1" ]
then
  echo "error: No argument specified."
  exit 254
fi

echo "argument: $1"

if ! DATA=$(cat "/sys/block/$1/stat" 2>&1)
then
  echo "error: Couldn't get data for $1"
  exit 254
fi

DATA=( $DATA )

echo "reads: ${DATA[0]}"
echo "sector_reads: ${DATA[2]}"
echo "ticks_reads: ${DATA[3]}"
echo "writes: ${DATA[4]}"
echo "sector_writes: ${DATA[6]}"
echo "ticks_writes: ${DATA[7]}"
echo "sector_size: 512"
