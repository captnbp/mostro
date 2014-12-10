#!/bin/bash -e

echo "---"
echo "service: redis"
echo "version: 2014120901"

REDIS_PORT=${1:-6379}

if [ -n "$REDIS_HOST" ]
then
  ARGUMENT="${REDIS_HOST}:${REDIS_PORT}"
else
  ARGUMENT="${REDIS_PORT}"
fi

echo "argument: $ARGUMENT"

REDIS_HOST=${REDIS_HOST:-localhost}

COMMAND="redis-cli -h $REDIS_HOST -p $REDIS_PORT"

OLDIFS=$IFS

if [ -n "$REDIS_PASSWORD" ]
then
  COMMAND="$COMMAND -a ${REDIS_PASSWORD}"
fi

OUTPUT=$($COMMAND INFO)

for LINE in $OUTPUT
do
  IFS=":"
  LINE=( $LINE )

  KEY=${LINE[0]}
  VALUE=${LINE[1]}

  if [[ "$KEY" = "evicted_keys" || "$KEY" = "used_memory" || "$KEY" = "used_memory_rss" ]]
  then
    echo "${KEY}: ${VALUE}"
  fi
done

IFS=$OLDIFS

SLOWLOG=$($COMMAND --csv slowlog get 1)

IFS=','

SLOWLOG=( $SLOWLOG )

echo "slowlog_index: ${SLOWLOG[0]:-0}"
