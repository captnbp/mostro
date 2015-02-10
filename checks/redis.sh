#!/bin/bash -e

echo "---"
echo "service: redis"

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

  if [[ "$KEY" = "evicted_keys" || "$KEY" = "used_memory" || "$KEY" = "used_memory_rss" ]]
  then
    echo "${KEY}: ${VALUE}"
  fi
done

IFS=$OLDIFS

if ! SLOWLOG=$($COMMAND --csv slowlog get 1 2>&1)
then
  echo "error: \"$SLOWLOG\""
  exit 254
fi

IFS=','

SLOWLOG=( $SLOWLOG )

echo "slowlog_index: ${SLOWLOG[0]:-0}"
