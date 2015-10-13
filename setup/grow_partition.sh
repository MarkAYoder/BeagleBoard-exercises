#!/bin/bash
BONE=${1:-192.168.7.2}
ssh root@$BONE "/opt/scripts/tools/grow_partition.sh; reboot"
