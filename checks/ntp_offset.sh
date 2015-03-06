#!/bin/bash -e

echo "---"
echo "service: ntp_offset"

VARIABLES=$(ntpq -nc readvar 2>&1)

if [[ "$?" != "0" || $VARIABLES =~ ^ntpq ]]
then
  echo "error: \"$VARIABLES\""
  exit 254
fi

OFFSET=0
CONNECTED=0

if [[ "$VARIABLES" =~ offset=([-\.0-9]+) ]]
then
  OFFSET=${BASH_REMATCH[1]}
fi

if [[ "$VARIABLES" =~ refid=[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]
then
  CONNECTED=1
fi

echo "connected: $CONNECTED"
echo "offset: $OFFSET"
