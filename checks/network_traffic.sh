#!/bin/bash -e

echo "---"
echo "service: network_traffic"
echo "version: 2014120901"

if [ -z "$1" ]
then
  echo "error: No argument specified."
  exit 254
fi

echo "argument: $1"

if ! DATA=$(grep "$1:" /proc/net/dev)
then
  echo "error: \"Couldn't get data for $1\""
  exit 254
fi

DATA=( $DATA )

echo "rx_bytes: ${DATA[1]}"
echo "tx_bytes: ${DATA[9]}"
echo "rx_packets: ${DATA[2]}"
echo "tx_packets: ${DATA[10]}"
