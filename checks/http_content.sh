#!/bin/bash -e

echo "---"
echo "service: http_content"
echo "version: 2015051901"

CURL_TIMEOUT="8"

while getopts :t: OPT
do
  case $OPT in
    t)
      CURL_TIMEOUT="$OPTARG"
      ;;
  esac
done

shift $(( OPTIND - 1 ))

if [ -n "$1" ]
then
  ARGUMENT="$1"
  shift
else
  echo "error: Missing argument."
  exit 254
fi

echo "argument: $ARGUMENT"

if [ -n "$1" ]
then
  URL="$1"
  shift
else
  echo "error: You need to pass a URL to cURL."
  exit 254
fi

if [ -n "$1" ]
then
  STRING="$1"
  shift
else
  echo "error: You need to specify a string to find."
  exit 254
fi

if ! CONTENT=$(curl -sS -f --max-time "$CURL_TIMEOUT" $@ "$URL" 2>&1)
then
  echo "error: \"${CONTENT#curl: \([[:digit:]]*\) }\""
  exit 254
fi

COUNT=$(echo "$CONTENT" | grep "$STRING" | wc -l)
echo "count: $COUNT"
