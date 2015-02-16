#!/bin/bash -e

echo "---"
echo "service: redis"

REDIS_PORT=${1:-6379}

if [[ -n "$REDIS_HOST" ]]
then
  ARGUMENT="${REDIS_HOST}:${REDIS_PORT}"
else
  ARGUMENT="${REDIS_PORT}"
fi

echo "argument: $ARGUMENT"

REDIS_HOST=${REDIS_HOST:-localhost}

COMMAND="redis-cli -h $REDIS_HOST -p $REDIS_PORT"

if [[ -n "$REDIS_PASSWORD" ]]
then
  COMMAND="$COMMAND -a ${REDIS_PASSWORD}"
fi

if ! OUTPUT=$($COMMAND INFO 2>&1)
then
  echo "error: \"$OUTPUT\""
  exit 254
fi

for LINE in $OUTPUT
do
  IFS=":"
  LINE=( $LINE )

  KEY=${LINE[0]}
  VALUE=${LINE[1]}

  if [[ "$KEY" = "last_save_time" ]]
  then
    KEY="rdb_last_save_time"
  fi

  if [[ "$KEY" = "last_bgsave_status" ]]
  then
    KEY="rdb_last_bgsave_status"
  fi

  if [[ "$KEY" = "rdb_last_bgsave_status" || "$KEY" = "aof_last_bgrewrite_status" ]]
  then
    if [[ "$VALUE" =~ ok ]]
    then
      VALUE=1
    else
      VALUE=0
    fi
  fi

  if [[ \
    "$KEY" = "connected_clients" || \
    "$KEY" = "used_memory" || \
    "$KEY" = "used_memory_rss" || \
    "$KEY" = "rdb_last_save_time" || \
    "$KEY" = "rdb_last_bgsave_status" || \
    "$KEY" = "aof_enabled" || \
    "$KEY" = "aof_last_bgrewrite_status" || \
    "$KEY" = "total_connections_received" || \
    "$KEY" = "total_commands_processed" || \
    "$KEY" = "rejected_connections" || \
    "$KEY" = "expired_keys" || \
    "$KEY" = "evicted_keys" || \
    "$KEY" = "keyspace_hits" || \
    "$KEY" = "keyspace_misses" || \
    "$KEY" = "connected_slaves"
  ]]
  then
    echo "${KEY}: ${VALUE}"
  fi
done
