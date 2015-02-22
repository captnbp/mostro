#!/bin/bash -e

echo "---"
echo "service: md_raid"

MDSTAT=$(</proc/mdstat)

IFS=$'\n'

REGEX_FAILED="\(F\)"
REGEX_ARRAY="\[[0-9]/[0-9]\] \[[A-Z]+\]"

ARRAYS=0

for LINE in $MDSTAT
do
  if [[ "$LINE" =~ $REGEX_FAILED ]]
  then
    echo "error: \"Array failure: ${LINE}\""
    exit 254
  fi

  if [[ "$LINE" =~ $REGEX_ARRAY ]]
  then
    ((ARRAYS=ARRAYS+1))
  fi
done

echo "arrays_count: $ARRAYS"
