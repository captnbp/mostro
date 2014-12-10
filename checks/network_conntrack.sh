#!/bin/bash -e

echo "---"
echo "service: network_conntrack"
echo "version: 2014120901"

COUNT=$(sysctl -n net.netfilter.nf_conntrack_count)
MAX=$(sysctl -n net.netfilter.nf_conntrack_max)

echo "count: $COUNT"
echo "max: $MAX"
