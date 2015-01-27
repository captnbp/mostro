#!/bin/bash -e

echo "---"
echo "service: disk_io"
echo "version: 2014120901"

if [ -z "$1" ]
then
  echo "error: No argument specified."
  exit
fi

echo "argument: $1"

if ! DATA=$(cat "/sys/block/$1/stat" 2>&1) || ! SECTORSIZE=$(cat "/sys/block/$1/queue/hw_sector_size" 2>&1)
then
  echo "error: Couldn't get data for $1"
  exit
fi

DATA=( $DATA )

echo "reads: ${DATA[0]}"
echo "writes: ${DATA[4]}"
echo "sector_reads: ${DATA[2]}"
echo "sector_writes: ${DATA[6]}"
echo "sector_size: $SECTORSIZE"
