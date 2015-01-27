#!/bin/bash -e

echo "---"
echo "service: mysql"
echo "version: 2014120901"

MYSQL_HOST=${MYSQL_HOST:-localhost}

if ! STATUS=$(mysql --host="$MYSQL_HOST" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" -e "SHOW GLOBAL STATUS" 2>&1)
then
  echo "error: \"$STATUS\""
  exit
fi

IFS=$'\n'

for LINE in ${STATUS,,}
do
  IFS=$'\t'

  LINE=( $LINE )

  KEY=${LINE[0]}
  VALUE=${LINE[1]}

  if [[ "$KEY" = "com_select" || "$KEY" = "com_insert" || "$KEY" = "com_update" || "$KEY" = "com_delete" || "$KEY" = "com_commit" || "$KEY" = "com_rollback" || "$KEY" = "connections" || "$KEY" = "slow_queries" || "$KEY" = "created_tmp_disk_tables" || "$KEY" = "created_tmp_tables" || "$KEY" = "qcache_hits" ]]
  then
    echo "${KEY}: ${VALUE}"
  fi
done
