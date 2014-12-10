#!/bin/bash -e

echo "---"
echo "service: cpu"
echo "version: 2014120901"

PROCSTAT=$(grep '^cpu\s' /proc/stat)
PROCSTAT=( $PROCSTAT )

echo "cpu_cycles_user: ${PROCSTAT[1]}"
echo "cpu_cycles_nice: ${PROCSTAT[2]}"
echo "cpu_cycles_system: ${PROCSTAT[3]}"
echo "cpu_cycles_iowait: ${PROCSTAT[5]}"
echo "cpu_cycles_irq: ${PROCSTAT[6]}"
echo "cpu_cycles_softirq: ${PROCSTAT[7]}"
echo "cpu_cycles_steal: ${PROCSTAT[8]}"
echo "cpu_cycles_guest: ${PROCSTAT[9]}"
echo "cpu_cycles_guestnice: ${PROCSTAT[10]}"
echo "cpu_cycles_idle: ${PROCSTAT[4]}"
