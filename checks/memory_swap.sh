#!/bin/bash -e

echo "---"
echo "service: memory_swap"
echo "version: 2015051901"

MEMINFO=$(</proc/meminfo)

IFS=$'\n'

REGEX_TOTAL="^SwapTotal:\s+([0-9]+) kB"
REGEX_FREE="^SwapFree:\s+([0-9]+) kB"

for LINE in $MEMINFO
do
  if [[ $LINE =~ $REGEX_TOTAL ]]
  then
    echo "total_kb: ${BASH_REMATCH[1]}"
  elif [[ $LINE =~ $REGEX_FREE ]]
  then
    echo "free_kb: ${BASH_REMATCH[1]}"
  fi
done
