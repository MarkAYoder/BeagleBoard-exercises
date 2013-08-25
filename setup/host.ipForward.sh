#!/bin/bash
# These are the commands to run on the host to setup IP masquerading so the Beagle
#  can access the Internet through the USB connection.
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
# Setup  IP masquerading on the host
sudo iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o $interface -j MASQUERADE

# Check to see what nameservers the host is using and copy these to the same
#  file on the Beagle
# This makes it so you can connect to the Beagle without using your password.
ssh-copy-id root@$beagleAddr
# Save the /etc/resolv.conf on the Beagle in case we mess things up.
ssh root@$beagleAddr "mv -n /etc/resolv.conf /etc/resolv.conf.orig"
# Copy the resolv.conf file to the Beagle.  Now the Beagle will use the
# same name servers as the host.
cat - << EOF > /tmp/resolv.conf
# This is installed by host.ipForward.sh on the host
# Mark A. Yoder, 25-Aug-2013
search rose-hulman.edu dhcp.rose-hulman.edu wlan.rose-hulman.edu

EOF

# Use the campus name servers if on compus, otherwise use the Google name servers
if ifconfig | grep "addr:137.112."; then
cat - << EOF >> /tmp/resolv.conf
nameserver 137.112.18.59
nameserver 137.112.5.28
nameserver 137.112.4.196
EOF
else
cat - << EOF >> /tmp/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF
fi
scp /tmp/resolv.conf root@$beagleAddr:/etc
# Tell the beagle to use the host as the gateway.
ssh root@$beagleAddr "/sbin/route add default gw $hostAddr"

