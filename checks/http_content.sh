#!/bin/bash

echo "---"
echo "service: http_content"
echo "version: 2014120901"

if [ -n "$1" ]
then
  ARGUMENT="$1"
  shift
else
  echo "Missing argument."
  exit 1
fi

echo "argument: $ARGUMENT"

if [ -n "$1" ]
then
  URL="$1"
  shift
else
  echo "You need to pass a URL to cURL."
  exit 1
fi

if [ -n "$1" ]
then
  STRING="$1"
  shift
else
  echo "You need to specify a string to find."
  exit 1
fi

COUNT=$(curl -s -f --max-time 8 $@ "$URL" | grep -c "$STRING")

echo "count: $COUNT"
