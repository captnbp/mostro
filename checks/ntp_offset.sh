#!/bin/bash -e

echo "---"
echo "service: ntp_offset"
echo "version: 2014120901"

PEERS=$(ntpq -nc peers 2>&1)

if [[ "$?" != "0" || $PEERS =~ ^ntpq ]]
then
  echo "error: \"$PEERS\""
  exit
fi

OFFSET=$(echo "$PEERS" | grep '^\*' | awk '{ print $9 }')

if [ -z "$OFFSET" ]
then
  echo "error: No active peer."
  exit
fi

echo "offset: $OFFSET"
