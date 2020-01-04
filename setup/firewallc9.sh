#!/bin/bash
# This blocks port 3000 which cloud9 runs on
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
PORT=3000
if [[ $1 == 'on' ]]; then
   echo Blocking port $PORT
   iptables -A INPUT -p tcp --destination-port $PORT -j DROP
else
# Switch -A to -D to delete rule
   echo Opening port $PORT
   iptables -D INPUT -p tcp --destination-port $PORT -j DROP
fi