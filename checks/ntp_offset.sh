#!/bin/bash -e

echo "---"
echo "service: ntp_offset"

PEERS=$(ntpq -nc peers 2>&1)

if [[ "$?" != "0" || $PEERS =~ ^ntpq ]]
then
  echo "error: \"$PEERS\""
  exit 254
fi

OFFSET=$(echo "$PEERS" | grep '^\*' | awk '{ print $9 }')

if [ -z "$OFFSET" ]
then
  echo "error: No active peer."
  exit 254
fi

echo "offset: $OFFSET"
