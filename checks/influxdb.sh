#!/bin/bash -e

echo "---"
echo "service: influxdb"

INFLUXDB_HOST=${INFLUXDB_HOST:-"localhost:8086"}
INFLUXDB_USER=${INFLUXDB_USER:-root}
INFLUXDB_PASSWORD=${INFLUXDB_PASSWORD:-root}

if ! OUTPUT=$(curl -sS -f "http://${INFLUXDB_HOST}/db?u=${INFLUXDB_USER}&p=${INFLUXDB_PASSWORD}" 2>&1)
then
  echo "error: \"$OUTPUT\""
  exit 254
fi

DATABASE_COUNT=$(echo "$OUTPUT" | grep -o '"name":' | wc -l)

echo "database_count: ${DATABASE_COUNT}"
