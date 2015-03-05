#!/bin/bash

echo "---"
echo "service: tcp"

while getopts :h:t: OPT
do
  case $OPT in
    h)
      HOST="$OPTARG"
      ;;

    t)
      TIMEOUT="$OPTARG"
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "$1" ]
then
  echo "error: No port specified."
  exit 254
fi

PORT="$1"
ARGUMENT="$PORT"

if [ -n "$HOST" ]
then
  ARGUMENT="$HOST:$PORT"
else
  HOST="127.0.0.1"
fi

if [ -z "$TIMEOUT" ]
then
  TIMEOUT="5"
fi

echo "argument: $ARGUMENT"

exec 3>&1

function display_time {
  read TIME
  echo "time_total: $TIME" >&3
}

if ! OUTPUT=$(echo -n | command time -o >(display_time) --quiet -f "%e" nc -w "$TIMEOUT" -v "$HOST" "$1" 2>&1 >/dev/null)
then
  echo "error: \"$OUTPUT\""
fi
