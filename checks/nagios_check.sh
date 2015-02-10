#!/bin/bash

# Usage: nagios_check.sh check_name check_full_path
#   e.g. nagios_check.sh "HTTP Status" /usr/lib/nagios/plugins/check_http -H mostro.com

echo "---"
echo "service: nagios_check"

ARGUMENT="$1"
shift

if [ -z "$ARGUMENT" ]
then
  echo "error: You have to give a check name."
  exit 254
fi

if [ -z "$1" ]
then
  echo "error: You have to specify a Nagios check."
  exit 254
fi

echo "argument: $ARGUMENT"

$@ >/dev/null

echo "return_code: $?"
