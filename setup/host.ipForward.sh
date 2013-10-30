#!/bin/bash
# These are the commands to run on the host to setup IP masquerading so the Beagle
#  can access the Internet through the USB connection.
# This configures the host then runs ./host.setDNS.sh to configure the bone.
# Inspired by http://thoughtshubham.blogspot.com/2010/03/internet-over-usb-otg-on-beagleboard.html

if [ $# -eq 0 ] ; then
echo "Usage: $0 interface (such as eth0 or wlan0)"
exit 1
fi

interface=$1
hostAddr=192.168.7.1
beagleAddr=192.168.7.2
ip_forward=/proc/sys/net/ipv4/ip_forward

if [ `cat $ip_forward` == 0 ]
  then
    echo "You need to set IP forwarding. Edit /etc/sysctl.conf using:"
    echo "$ sudo gedit /etc/sysctl.conf"
    echo "and uncomment the line   \"net.ipv4.ip_forward=1\""
    echo "to enable forwarding of packets. Then run the following:"
    echo "$ sudo sysctl -p"
    exit 1
  else
    echo "IP forwarding is set on host."
fi
# Setup  IP masquerading on the host so the bone can reach the outside world
sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o $interface -j MASQUERADE

# Setup port forwards on 3000, 8080 and 1080 so outside world can reach the bone
# first get IP address of host outside interface
IP_ADDR=`ifconfig $interface | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'`
# Now forward, first forwards 1080 to 80
# sudo iptables -t nat -A PREROUTING -p tcp -s 0/0 -d $IP_ADDR --dport 1080 -j DNAT --to $beagleAddr:80
# sudo iptables -t nat -A PREROUTING -p tcp -s 0/0 -d $IP_ADDR --dport 3000 -j DNAT --to $beagleAddr:3000
# sudo iptables -t nat -A PREROUTING -p tcp -s 0/0 -d $IP_ADDR --dport 8080 -j DNAT --to $beagleAddr:8080

# Check to see what nameservers the host is using and copy these to the same
#  file on the Beagle
# This makes it so you can connect to the Beagle without using your password.
ssh-copy-id root@$beagleAddr
# Update the /etc/resovl.conf on the Bone 
./host.setDNS.sh
