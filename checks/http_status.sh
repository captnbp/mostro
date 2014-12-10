#!/bin/bash

echo "---"
echo "service: http_status"
echo "version: 2014120901"

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

curl -o /dev/null -w "$FORMAT" -s -f --max-time 8 $@ "$URL" || true
