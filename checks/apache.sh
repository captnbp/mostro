#!/bin/bash -e

echo "---"
echo "service: apache"

APACHE_STATUS_URL=${1:-"http://localhost/server-status"}

IFS=$'\n'

if ! OUTPUT=$(curl -sS -f "$APACHE_STATUS_URL" 2>&1)
then
  echo "error: \"$OUTPUT\""
  exit 254
fi

REGEX="([0-9]+)\s+requests\s+currently\s+being\s+processed,\s+([0-9]+)\s+idle\s+"

for LINE in $OUTPUT
do
  if [[ "$LINE" =~ $REGEX ]]
  then
    echo "active_workers: ${BASH_REMATCH[1]}"
    echo "idle_workers: ${BASH_REMATCH[2]}"
    exit 0
  fi
done

echo "error: \"Couldn't retrieve statistics from Apache\""
exit 254
