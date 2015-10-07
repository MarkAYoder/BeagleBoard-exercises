#!/bin/bash
# Copy host's date to bone
BONE=${1:-192.168.7.2}
DATE=`date`
ssh root@$BONE "date -s \"$DATE\""
