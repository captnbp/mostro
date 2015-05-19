#!/bin/bash -e

echo "---"
echo "service: mysql"
echo "version: 2015051901"

while getopts :h:u:p: OPT
do
  case $OPT in
    h)
      MYSQL_HOST="$OPTARG"
      ;;
    u)
      MYSQL_USER="$OPTARG"
      ;;
    p)
      MYSQL_PASSWORD="$OPTARG"
      ;;
  esac
done

if [[ -z "$MYSQL_HOST" ]]
then
  MYSQL_HOST="localhost"
fi

if [[ -n "$MYSQL_USER" ]]
then
  MYSQL_USER="--user=${MYSQL_USER}"
fi

if [[ -n "$MYSQL_PASSWORD" ]]
then
  MYSQL_PASSWORD="--password=${MYSQL_PASSWORD}"
fi

if ! STATUS=$(mysql --host="$MYSQL_HOST" $MYSQL_USER $MYSQL_PASSWORD -e "SHOW GLOBAL VARIABLES; SHOW GLOBAL STATUS" 2>&1)
then
  echo "error: \"$STATUS\""
  exit 254
fi

IFS=$'\n'

STATUS=$(echo "$STATUS" | tr '[:upper:]' '[:lower:]')

for LINE in $STATUS
do
  IFS=$'\t'

  LINE=( $LINE )

  KEY=${LINE[0]}
  VALUE=${LINE[1]}

  if [[ \
    "$KEY" = "aborted_clients" || \
    "$KEY" = "aborted_connects" || \
    "$KEY" = "bytes_received" || \
    "$KEY" = "bytes_sent" || \
    "$KEY" = "com_begin" || \
    "$KEY" = "com_commit" || \
    "$KEY" = "com_delete" || \
    "$KEY" = "com_insert" || \
    "$KEY" = "com_replace" || \
    "$KEY" = "com_rollback" || \
    "$KEY" = "com_select" || \
    "$KEY" = "com_update" || \
    "$KEY" = "connect_timeout" || \
    "$KEY" = "connections" || \
    "$KEY" = "created_tmp_disk_tables" || \
    "$KEY" = "created_tmp_tables" || \
    "$KEY" = "handler_read_first" || \
    "$KEY" = "handler_read_key" || \
    "$KEY" = "handler_read_next" || \
    "$KEY" = "handler_read_prev" || \
    "$KEY" = "handler_read_rnd" || \
    "$KEY" = "handler_read_rnd_next" || \
    "$KEY" = "innodb_buffer_pool_pages_dirty" || \
    "$KEY" = "innodb_buffer_pool_pages_total" || \
    "$KEY" = "innodb_buffer_pool_read_requests" || \
    "$KEY" = "innodb_buffer_pool_reads" || \
    "$KEY" = "innodb_buffer_pool_wait_free" || \
    "$KEY" = "innodb_buffer_pool_write_requests" || \
    "$KEY" = "innodb_log_waits" || \
    "$KEY" = "innodb_log_writes" || \
    "$KEY" = "interactive_timeout" || \
    "$KEY" = "key_blocks_unused" || \
    "$KEY" = "key_buffer_size" || \
    "$KEY" = "key_cache_block_size" || \
    "$KEY" = "key_read_requests" || \
    "$KEY" = "key_reads" || \
    "$KEY" = "max_connect_errors" || \
    "$KEY" = "max_connections" || \
    "$KEY" = "max_used_connections" || \
    "$KEY" = "max_heap_table_size" || \
    "$KEY" = "open_files" || \
    "$KEY" = "open_files_limit" || \
    "$KEY" = "open_tables" || \
    "$KEY" = "opened_tables" || \
    "$KEY" = "qcache_free_blocks" || \
    "$KEY" = "qcache_free_memory" || \
    "$KEY" = "qcache_hits" || \
    "$KEY" = "qcache_inserts" || \
    "$KEY" = "qcache_lowmem_prunes" || \
    "$KEY" = "qcache_not_cached" || \
    "$KEY" = "qcache_queries_in_cache" || \
    "$KEY" = "qcache_total_blocks" || \
    "$KEY" = "query_cache_min_res_unit" || \
    "$KEY" = "query_cache_size" || \
    "$KEY" = "query_cache_type" || \
    "$KEY" = "questions" || \
    "$KEY" = "select_full_join" || \
    "$KEY" = "select_range_check" || \
    "$KEY" = "skip_name_resolve" || \
    "$KEY" = "slow_queries" || \
    "$KEY" = "sort_merge_passes" || \
    "$KEY" = "sort_range" || \
    "$KEY" = "sort_scan" || \
    "$KEY" = "table_locks_immediate" || \
    "$KEY" = "table_locks_waited" || \
    "$KEY" = "table_open_cache" || \
    "$KEY" = "threads_connected" || \
    "$KEY" = "thread_cache_size" || \
    "$KEY" = "threads_created" || \
    "$KEY" = "tmp_table_size" || \
    "$KEY" = "wait_timeout"
  ]]
  then
    if [ "$KEY" = "query_cache_type" ]
    then
      if [ "$VALUE" = "on" ]
      then
        VALUE=1
      elif [ "$VALUE" = "demand" ]
      then
        VALUE=2
      else
        VALUE=0
      fi
    fi

    echo "${KEY}: ${VALUE}"
  fi
done
