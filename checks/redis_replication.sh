#!/bin/bash -e

echo "---"
echo "service: redis_replication"

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

  if [ "$KEY" = "master_link_status" ]
  then
    if [[ "$VALUE" =~ up ]]
    then
      VALUE=1
    else
      VALUE=0
    fi
  fi

  if [[ "$KEY" = "master_last_io_seconds_ago" || "$KEY" = "master_link_status" ]]
  then
    echo "${KEY}: ${VALUE}"
  fi
done
