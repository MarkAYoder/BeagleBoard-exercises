#!/bin/bash
# These are the commands to run on the host to setup port forwarding to the bone

if [ $# -eq 0 ] ; then
echo "Usage: $0 interface (eth0) portNumber"
exit 1
fi

interface=$1
port=$2
hostAddr=192.168.7.1
beagleAddr=192.168.7.2

# Setup port forwards on 3000, 8080 and 1080 so outside world can reach the bone
# first get IP address of host outside interface
# 3000 is cloud9
# 9090 is boneServer
# 1080 is the standard webserver mapped to 80 on the bone
# 5900 is x11vnc
IP_ADDR=`ifconfig $interface | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
echo $IP_ADDR
sudo iptables -t nat -A PREROUTING -p tcp -s 0/0 -d $IP_ADDR --dport $port -j DNAT --to $beagleAddr:$port

