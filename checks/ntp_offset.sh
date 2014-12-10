#!/bin/bash -e

echo "---"
echo "service: ntp_offset"
echo "version: 2014120901"

PEERS=$(ntpq -nc peers)

OFFSET=$(echo "$PEERS" | grep '^\*' | awk '{ print $9 }')

if [ -z "$OFFSET" ]
then
  echo "Invalid offset" 1>&2
  exit 1
fi

echo "offset: $OFFSET"
