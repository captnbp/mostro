#!/bin/bash

echo "---"
echo "service: http_status"

CURL_TIMEOUT="8"

while getopts :t: OPT
do
  case $OPT in
    t)
      CURL_TIMEOUT="$OPTARG"
      ;;
  esac
done

shift $(( OPTIND - 1 ))

ARGUMENT=${1:-default}
shift

echo "argument: $ARGUMENT"

if [ "$ARGUMENT" != "default" ]
then
  if [ -z "$1" ]
  then
    echo "error: No URL specified"
    exit 254
  fi
fi

URL=${1:-"http://localhost/"}
shift

read -r -d '' FORMAT <<EOF
http_code: %{http_code}
size_download: %{size_download}
time_namelookup: %{time_namelookup}
time_connect: %{time_connect}
time_pretransfer: %{time_pretransfer}
time_starttransfer: %{time_starttransfer}
time_total: %{time_total}\n
EOF

exec 3>&1
ERROR=$(curl -o /dev/null -w "$FORMAT" -sS --max-time "$CURL_TIMEOUT" $@ "$URL" 2>&1 1>&3)

if [ "$?" != "0" ]
then
  echo "error: \"${ERROR#curl: \([[:digit:]]*\) }\""
  exit 254
fi
