#!/bin/bash -e

echo "---"
echo "service: nginx"
echo "version: 2014120901"

NGINX_STATUS_URL=${1:-"http://localhost/nginx_status"}

IFS=$'\n'

if ! OUTPUT=$(curl -sS -f "$NGINX_STATUS_URL" 2>&1)
then
  echo "error: \"$OUTPUT\""
  exit
fi

for LINE in $OUTPUT
do
  REGEX_ACTIVE="Active connections: ([0-9]+)"
  REGEX_CONNECTIONS=" ([0-9]+) ([0-9]+) ([0-9]+)"

  if [[ "$LINE" =~ $REGEX_ACTIVE ]]
  then
    echo "active_connections: ${BASH_REMATCH[1]}"
  elif [[ "$LINE" =~ $REGEX_CONNECTIONS ]]
  then
    echo "total_connections: ${BASH_REMATCH[1]}"
    echo "total_requests: ${BASH_REMATCH[3]}"
  fi
done
