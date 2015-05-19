#!/bin/bash -e

echo "---"
echo "service: mysql_replication"
echo "version: 2015051901"

MYSQL_HOST=${MYSQL_HOST:-localhost}

if [[ -n "$MYSQL_USER" ]]
then
  MYSQL_USER="--user=$MYSQL_USER"
fi

if [[ -n "$MYSQL_PASSWORD" ]]
then
  MYSQL_PASSWORD="--password=$MYSQL_PASSWORD"
fi

if ! STATUS=$(mysql --host="$MYSQL_HOST" $MYSQL_USER $MYSQL_PASSWORD -e "SHOW SLAVE STATUS\G" 2>&1)
then
  echo "error: \"$STATUS\""
  exit 254
fi

SECONDS_BEHIND_MASTER=$(echo "$STATUS" | grep 'Seconds_Behind_Master' | tr -d ' ' | cut -f2 -d':')

echo "seconds_behind_master: $SECONDS_BEHIND_MASTER"
