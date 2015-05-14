#!/bin/bash

echo "---"
echo "service: postgresql"

while getopts :h:u:p: OPT
do
  case $OPT in
    h)
      POSTGRESQL_HOST="$OPTARG"
      ;;
    u)
      POSTGRESQL_USER="$OPTARG"
      ;;
    p)
      PGPASSWORD="$OPTARG"
      ;;
    t)
      PGCONNECT_TIMEOUT="$OPTARG"
      ;;
  esac
done

shift $(( OPTIND - 1 ))

if [[ -z "$PGCONNECT_TIMEOUT" ]]
then
  PGCONNECT_TIMEOUT=5
fi

export PGCONNECT_TIMEOUT

if [[ -n "$POSTGRESQL_USER" ]]
then
  POSTGRESQL_USER="-U ${POSTGRESQL_USER}"

  if [[ -z "$POSTGRESQL_HOST" ]]
  then
    POSTGRESQL_HOST="127.0.0.1"
  fi
fi

if [[ -n "$POSTGRESQL_HOST" ]]
then
  POSTGRESQL_HOST="-h ${POSTGRESQL_HOST}"
fi

export PGPASSWORD

STATUS=$(psql $POSTGRESQL_HOST $POSTGRESQL_USER -w -A -F": " -X -t -x postgres 2>&1 <<EOF
SELECT
SUM(numbackends) AS numbackends,
SUM(xact_commit) AS xact_commit,
SUM(xact_rollback) AS xact_rollback,
SUM(blks_read) AS blks_read,
SUM(blks_hit) AS blks_hit,
SUM(tup_returned) AS tup_returned,
SUM(tup_fetched) AS tup_fetched,
SUM(tup_inserted) AS tup_inserted,
SUM(tup_updated) AS tup_updated,
SUM(tup_deleted) AS tup_deleted
FROM pg_stat_database
WHERE datname not ilike 'template%%'
AND datname not ilike 'postgres';

SELECT setting AS max_connections FROM pg_settings WHERE name = 'max_connections';
SELECT setting AS wal_buffers FROM pg_settings WHERE name = 'wal_buffers';
SELECT setting AS shared_buffers FROM pg_settings WHERE name = 'shared_buffers';
SELECT setting AS effective_cache_size FROM pg_settings WHERE name = 'effective_cache_size';
SELECT setting AS work_mem FROM pg_settings WHERE name = 'work_mem';
SELECT setting AS maintenance_work_mem FROM pg_settings WHERE name = 'maintenance_work_mem';
SELECT setting AS checkpoint_segments FROM pg_settings WHERE name = 'checkpoint_segments';
SELECT setting AS checkpoint_completion_target FROM pg_settings WHERE name = 'checkpoint_completion_target';
EOF
)

if [[ "$?" != "0" ]]
then
  echo "error: >"
  STATUS=$(echo "$STATUS" | head -n1)
  echo "  ${STATUS#psql: }"
  exit 254
fi

echo "$STATUS"
