#!/bin/bash -e

echo "---"
echo "service: memcache"
echo "version: 2014120901"

MEMCACHE_PORT=${1:-11211}

if [ -n "$MEMCACHE_HOST" ]
then
  ARGUMENT="${MEMCACHE_HOST}:${MEMCACHE_PORT}"
else
  ARGUMENT="${MEMCACHE_PORT}"
fi

echo "argument: $ARGUMENT"

IFS=$'\r\n'

MEMCACHE_HOST=${MEMCACHE_HOST:-127.0.0.1}

if ! OUTPUT=$(echo -e "stats\nquit" | nc -v "$MEMCACHE_HOST" "$MEMCACHE_PORT" 2>&1)
then
  echo "error: \"$OUTPUT\""
  exit
fi

for LINE in $OUTPUT
do
  IFS=$' '
  LINE=( $LINE )

  KEY=${LINE[1]}
  VALUE=${LINE[2]}

  if [ "${#D[@]}" = "3" ]
  then
    DATA+=(["${D[1]}"]="${D[2]}")
  fi

  if [[ "$KEY" = "cmd_get" || "$KEY" = "cmd_set" || "$KEY" = "get_hits" || "$KEY" = "evictions" ]]
  then
    echo "${KEY}: ${VALUE}"
  fi
done
