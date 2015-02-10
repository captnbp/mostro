#!/bin/bash -e

echo "---"
echo "service: memory_swap_paging"

grep '^pswp' /proc/vmstat | sed 's/ /: /'
echo -n "page_size: "
getconf PAGESIZE
