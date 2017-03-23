#!/bin/bash
BONE=${1:-192.168.7.2}
USER=debian
./setDNS.sh $BONE
./setDate.sh $BONE
ssh -X $USER@$BONE
