#!/bin/bash -e

echo "---"
echo "service: memcache"

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

if ! OUTPUT=$(echo -e "stats settings\nstats slabs\nstats\nquit" | nc -v "$MEMCACHE_HOST" "$MEMCACHE_PORT" 2>&1)
then
  echo "error: \"$OUTPUT\""
  exit 254
fi

for LINE in $OUTPUT
do
  IFS=$' '
  LINE=( $LINE )

  KEY=${LINE[1]}
  VALUE=${LINE[2]}

  if [[ \
    "$KEY" = "curr_connections" || \
    "$KEY" = "total_connections" || \
    "$KEY" = "cmd_get" || \
    "$KEY" = "cmd_set" || \
    "$KEY" = "cmd_flush" || \
    "$KEY" = "cmd_touch" || \
    "$KEY" = "get_hits" || \
    "$KEY" = "get_misses" || \
    "$KEY" = "delete_misses" || \
    "$KEY" = "delete_hits" || \
    "$KEY" = "incr_misses" || \
    "$KEY" = "incr_hits" || \
    "$KEY" = "decr_misses" || \
    "$KEY" = "decr_hits" || \
    "$KEY" = "cas_misses" || \
    "$KEY" = "cas_hits" || \
    "$KEY" = "cas_badval" || \
    "$KEY" = "touch_hits" || \
    "$KEY" = "touch_misses" || \
    "$KEY" = "bytes_read" || \
    "$KEY" = "bytes_written" || \
    "$KEY" = "limit_maxbytes" || \
    "$KEY" = "bytes" || \
    "$KEY" = "curr_items" || \
    "$KEY" = "total_items" || \
    "$KEY" = "evictions" || \
    "$KEY" = "reclaimed" || \
    "$KEY" = "maxconns" || \
    "$KEY" = "active_slabs" || \
    "$KEY" = "total_malloced"
  ]]
  then
    if [[ "$VALUE" =~ ^[0-9]+$ ]]
    then
      echo "${KEY}: ${VALUE}"
    fi
  fi
done
