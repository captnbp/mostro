#!/bin/bash -e

echo "---"
echo "service: network_conntrack"

COUNT=$(sysctl -n net.netfilter.nf_conntrack_count)
MAX=$(sysctl -n net.netfilter.nf_conntrack_max)

echo "count: $COUNT"
echo "max: $MAX"
