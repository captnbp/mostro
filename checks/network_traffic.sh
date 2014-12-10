#!/bin/bash -e

echo "---"
echo "service: network_traffic"
echo "version: 2014120901"

if [ -z "$1" ]
then
  echo "No argument specified." 1>&2
  exit 1
fi

echo "argument: $1"

DATA=$(grep "$1:" /proc/net/dev)

DATA=( $DATA )
echo "rx_bytes: ${DATA[1]}"
echo "tx_bytes: ${DATA[9]}"
echo "rx_packets: ${DATA[2]}"
echo "tx_packets: ${DATA[10]}"
