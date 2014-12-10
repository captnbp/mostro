#!/bin/bash -e

echo "---"
echo "service: forks"
echo "version: 2014120901"

COUNT=$(awk '/processes/ {print $2}' /proc/stat)

echo "count: $COUNT"
