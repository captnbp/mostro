#!/bin/bash -e

echo "---"
echo "service: mysql_replication"
echo "version: 2014120901"

MYSQL_HOST=${MYSQL_HOST:-localhost}

if ! STATUS=$(mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" -e "SHOW SLAVE STATUS\G" 2>&1)
then
  echo "error: \"$STATUS\""
  exit
fi

SECONDS_BEHIND_MASTER=$(echo "$STATUS" | grep 'Seconds_Behind_Master' | tr -d ' ' | cut -f2 -d':')

echo "seconds_behind_master: $SECONDS_BEHIND_MASTER"
