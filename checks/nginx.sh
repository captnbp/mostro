#!/bin/bash -e

echo "---"
echo "service: nginx"
echo "version: 2015052101"

NGINX_STATUS_URL=${1:-"http://localhost/nginx_status"}

IFS=$'\n'

if ! OUTPUT=$(curl -sS -f "$NGINX_STATUS_URL" 2>&1)
then
  echo "error: \"$OUTPUT\""
  exit 254
fi

for LINE in $OUTPUT
do
  REGEX_ACTIVE="Active connections: ([0-9]+)"
  REGEX_CONNECTIONS="^ ([0-9]+) ([0-9]+) ([0-9]+)"
  REGEX_DOING="^Reading: ([0-9]+) Writing: ([0-9]+) Waiting: ([0-9]+)"

  if [[ "$LINE" =~ $REGEX_ACTIVE ]]
  then
    echo "active_connections: ${BASH_REMATCH[1]}"
  elif [[ "$LINE" =~ $REGEX_CONNECTIONS ]]
  then
    echo "total_connections: ${BASH_REMATCH[1]}"
    echo "handled_connections: ${BASH_REMATCH[2]}"
    echo "total_requests: ${BASH_REMATCH[3]}"
  elif [[ "$LINE" =~ $REGEX_DOING ]]
  then
    echo "reading: ${BASH_REMATCH[1]}"
    echo "writing: ${BASH_REMATCH[2]}"
    echo "waiting: ${BASH_REMATCH[3]}"
  fi
done
