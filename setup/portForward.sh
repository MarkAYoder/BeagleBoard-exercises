#!/bin/bash
# Run these on the host to forward ports to the Bone.

if [ $# -lt 2 ] ; then
echo "Usage: $0 interface port [to port]"
echo "interface is eth0 or wlan0
Common  ports:
80	http
3000	cloud9
5900	vnc
9090	boneServer"
exit 1
fi

interface=$1
port=$2
port2=$2
if [ $# -eq 3 ] ; then
port2=$3
fi
hostAddr=192.168.7.1
beagleAddr=192.168.7.2

# Setup port forwards so outside world can reach the bone
# first get IP address of host outside interface
IP_ADDR=`ifconfig $interface | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
sudo iptables -t nat -A PREROUTING -p tcp -s 0/0 -d $IP_ADDR --dport $port -j DNAT --to $beagleAddr:$port2
# Replace -A with -D to delete forwarding
