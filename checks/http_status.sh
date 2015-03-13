#!/bin/bash

echo "---"
echo "service: http_status"

ARGUMENT=${1:-default}
shift

echo "argument: $ARGUMENT"

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

function log_error {
  read ERROR

  if [ -n "$ERROR" ]
  then
    echo "error: \"${ERROR#curl: \([[:digit:]]*\) }\"" >&3
  fi
}

coproc log_error

curl -o /dev/null -w "$FORMAT" -sS --max-time 8 $@ "$URL" 2>&"${COPROC[1]}" || true
