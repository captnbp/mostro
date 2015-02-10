#!/bin/bash -e

echo "---"
echo "service: forks"

COUNT=$(awk '/processes/ {print $2}' /proc/stat)

echo "count: $COUNT"
