#!/bin/bash -e

echo "---"
echo "service: process_count"

if [ "$1" = "-f" ]
then
  PGREP_ARGS="-f"
  shift
fi

if [ -z "$1" ]
then
  echo "error: No argument specified."
  exit 254
fi

echo "argument: $1"

SELF_PID=$$
COUNT=0

if PIDS=$(pgrep $PGREP_ARGS "$1")
then
  for PID in $PIDS
  do
    if [ "$PID" != "$SELF_PID" ]
    then
      COUNT=$((COUNT+1))
    fi
  done
fi

echo "count: $COUNT"
