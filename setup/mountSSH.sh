#!/bin/bash
# This sets options that lets ssh recover more quickly from dropped connections
# http://stackoverflow.com/questions/17686952/mounting-sshfs-on-unreliable-connection

HOST=${1:-office}
DIR1=${2:-~/cdrom}
DIR2=${3:-~/cdrom}

echo $HOST, $DIR1, $DIR2

sshfs -C -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 yoder@$HOST:$DIR1 $DIR2
