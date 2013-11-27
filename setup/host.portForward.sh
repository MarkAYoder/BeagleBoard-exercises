#!/bin/bash
# These are the commands to run on the host to setup port forwarding
# to the bone

if [ $# -eq 0 ] ; then
echo "Usage: $0 interface (such as eth0 or wlan0) port"
exit 1
fi

interface=$1
port=$2
hostAddr=192.168.7.1
beagleAddr=192.168.7.2

# first get IP address of host outside interface
IP_ADDR=`ifconfig $interface | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
sudo iptables -t nat -A PREROUTING -p tcp -s 0/0 -d $IP_ADDR --dport $port -j DNAT --to $beagleAddr:$port
