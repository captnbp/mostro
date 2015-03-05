#!/bin/bash

echo "---"
echo "service: tcp"

while getopts :h:t: OPT
do
  case $OPT in
    h)
      TCP_HOST="$OPTARG"
      ;;

    t)
      TCP_TIMEOUT="$OPTARG"
      ;;
  esac
done

shift $((OPTIND-1))

if [ -z "$1" ]
then
  echo "error: No port specified."
  exit 254
fi

TCP_PORT="$1"
ARGUMENT="$TCP_PORT"

if [ -n "$TCP_HOST" ]
then
  ARGUMENT="$TCP_HOST:$TCP_PORT"
else
  TCP_HOST="127.0.0.1"
fi

if [ -z "$TCP_TIMEOUT" ]
then
  TCP_TIMEOUT="5"
fi

echo "argument: $ARGUMENT"

exec 3>&1

function display_time {
  read TIME
  echo "time_total: $TIME" >&3
}

if ! OUTPUT=$(echo -n | command time -o >(display_time) --quiet -f "%e" nc -w "$TCP_TIMEOUT" -v "$TCP_HOST" "$1" 2>&1 >/dev/null)
then
  echo "error: \"$OUTPUT\""
fi
