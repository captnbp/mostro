#!/bin/bash -e

echo "---"
echo "service: redis_replication"
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

  if [ "$KEY" = "master_last_io_seconds_ago" ]
  then
    echo "${KEY}: ${VALUE}"
  fi

  if [ "$KEY" = "master_link_status" ]
  then
    if [[ "$VALUE" =~ up ]]
    then
      echo "${KEY}: 1"
    else
      echo "${KEY}: 0"
    fi
  fi
done
