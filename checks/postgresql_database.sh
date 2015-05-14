#!/bin/bash

echo "---"
echo "service: postgresql_database"

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

POSTGRESQL_DATABASE="$1"

if [[ -z "$POSTGRESQL_DATABASE" ]]
then
  echo "error: No database specified."
  exit 254
fi

if [[ -z "$PGCONNECT_TIMEOUT" ]]
then
  PGCONNECT_TIMEOUT=5
fi

export PGCONNECT_TIMEOUT

echo "argument: ${POSTGRESQL_DATABASE}"

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

STATUS=$(psql $POSTGRESQL_HOST $POSTGRESQL_USER -w -A -F": " -X -t -x "$POSTGRESQL_DATABASE" 2>&1 <<EOF
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
WHERE datname='${POSTGRESQL_DATABASE}';

SELECT
SUM(seq_scan) AS seq_scan,
SUM(seq_tup_read) AS seq_tup_read,
SUM(idx_scan) AS idx_scan,
SUM(idx_tup_fetch) AS idx_tup_fetch,
SUM(n_tup_ins) AS n_tup_ins,
SUM(n_tup_upd) AS n_tup_upd,
SUM(n_tup_del) AS n_tup_del,
SUM(n_tup_hot_upd) AS n_tup_hot_upd,
SUM(n_live_tup) AS n_live_tup,
SUM(n_dead_tup) AS n_dead_tup
FROM pg_stat_user_tables;

SELECT
SUM(heap_blks_read) AS heap_blks_read,
SUM(heap_blks_hit) AS heap_blks_hit,
SUM(idx_blks_read) AS idx_blks_read,
SUM(idx_blks_hit) AS idx_blks_hit,
SUM(toast_blks_read) AS toast_blks_read,
SUM(toast_blks_hit) AS toast_blks_hit,
SUM(tidx_blks_read) AS tidx_blks_read,
SUM(tidx_blks_hit) AS tidx_blks_hit
FROM pg_statio_user_tables;

SELECT pg_database_size('${POSTGRESQL_DATABASE}') AS pg_database_size;
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
