#!/bin/bash -e

echo "---"
echo "service: memory_swap_paging"
echo "version: 2014120901"

grep '^pswp' /proc/vmstat | sed 's/ /: /'
echo -n "page_size: "
getconf PAGESIZE
