#!/bin/bash
# This sets options that lets ssh recover more quickly from dropped connections
# http://stackoverflow.com/questions/17686952/mounting-sshfs-on-unreliable-connection

HOST=${1:-office}
DIR=${2:-~/cdrom}

echo $HOST
echo $DIR

sshfs -C -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 yoder@$HOST:$DIR $DIR
