#!/bin/bash -e

echo "---"
echo "service: disk_io"
echo "version: 2014120901"

if [ -z "$1" ]
then
  echo "No argument specified." 1>&2
	exit 1
fi

echo "argument: $1"

DATA=$(<"/sys/block/$1/stat")
SECTORSIZE=$(<"/sys/block/$1/queue/hw_sector_size")

DATA=( $DATA )
echo "reads: ${DATA[0]}"
echo "writes: ${DATA[4]}"
echo "sector_reads: ${DATA[2]}"
echo "sector_writes: ${DATA[6]}"
echo "sector_size: $SECTORSIZE"
