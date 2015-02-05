#!/bin/bash -e

echo "---"
echo "service: process_count"
echo "version: 2014120901"

if [ -z "$1" ]
then
  echo "error: No argument specified."
  exit 254
fi

echo "argument: $1"

COUNT=$(pgrep -c "$1")

echo "count: $COUNT"
