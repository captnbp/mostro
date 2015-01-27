#!/bin/bash

# Usage: nagios_check.sh check_name check_full_path
#   e.g. nagios_check.sh "HTTP Status" /usr/lib/nagios/plugins/check_http -H mostro.com

echo "---"
echo "service: nagios_check"
echo "version: 2014121601"

ARGUMENT="$1"
shift

if [ -z "$ARGUMENT" ]
then
  echo "error: You have to give a check name."
  exit
fi

if [ -z "$1" ]
then
  echo "error: You have to specify a Nagios check."
  exit
fi

echo "argument: $ARGUMENT"

$@ >/dev/null

echo "return_code: $?"
