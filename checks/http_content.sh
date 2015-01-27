#!/bin/bash -e

echo "---"
echo "service: http_content"
echo "version: 2014120901"

if [ -n "$1" ]
then
  ARGUMENT="$1"
  shift
else
  echo "error: Missing argument."
  exit
fi

echo "argument: $ARGUMENT"

if [ -n "$1" ]
then
  URL="$1"
  shift
else
  echo "error: You need to pass a URL to cURL."
  exit
fi

if [ -n "$1" ]
then
  STRING="$1"
  shift
else
  echo "error: You need to specify a string to find."
  exit
fi

if ! CONTENT=$(curl -sS -f --max-time 8 $@ "$URL" 2>&1)
then
  echo "error: \"$CONTENT\""
  exit
fi

COUNT=$(echo "$CONTENT" | grep "$STRING" | wc -l)
echo "count: $COUNT"
