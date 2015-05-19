#!/bin/bash -e

echo "---"
echo "service: memory_ram"
echo "version: 2015051901"

MEMINFO=$(</proc/meminfo)

IFS=$'\n'

REGEX_TOTAL="^MemTotal:\s+([0-9]+) kB"
REGEX_FREE="^MemFree:\s+([0-9]+) kB"
REGEX_CACHED="^Cached:\s+([0-9]+) kB"
REGEX_BUFFERS="^Buffers:\s+([0-9]+) kB"

for LINE in $MEMINFO
do
  if [[ $LINE =~ $REGEX_TOTAL ]]
  then
    echo "total_kb: ${BASH_REMATCH[1]}"
  elif [[ $LINE =~ $REGEX_FREE ]]
  then
    echo "free_kb: ${BASH_REMATCH[1]}"
  elif [[ $LINE =~ $REGEX_CACHED ]]
  then
    echo "cached_kb: ${BASH_REMATCH[1]}"
  elif [[ $LINE =~ $REGEX_BUFFERS ]]
  then
    echo "buffers_kb: ${BASH_REMATCH[1]}"
  fi
done
