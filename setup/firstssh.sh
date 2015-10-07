#!/bin/bash
BONE=${1:-192.168.7.2}
./setDNS.sh $BONE
./setDate.sh $BONE
ssh -X root@$BONE
