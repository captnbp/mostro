#!/bin/bash -e

echo "---"
echo "service: load_average"
echo "version: 2015051901"

LOADAVG=$(</proc/loadavg)

LOADAVG=( $LOADAVG )
echo "load_1min: ${LOADAVG[0]}"
echo "load_5min: ${LOADAVG[1]}"
echo "load_15min: ${LOADAVG[2]}"
