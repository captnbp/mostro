#!/bin/bash -e

echo "---"
echo "service: forks"
echo "version: 2015051901"

COUNT=$(awk '/processes/ {print $2}' /proc/stat)

echo "count: $COUNT"
