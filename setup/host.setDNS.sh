#!/bin/bash
# These are the commands to run on the host to setup IP masquerading so the Beagle
#  can access the Internet through the USB connection.
# Run host.ipForward.sh the first time. It will set up the host.
# Run this script if the host is already set up.
# Inspired by http://thoughtshubham.blogspot.com/2010/03/internet-over-usb-otg-on-beagleboard.html

hostAddr=192.168.7.1
beagleAddr=192.168.7.2

# Save the /etc/resolv.conf on the Beagle in case we mess things up.
ssh root@$beagleAddr "mv -n /etc/resolv.conf /etc/resolv.conf.orig"
# Copy the resolv.conf file to the Beagle.  Now the Beagle will use the
# same name servers as the host.
cat - << EOF > /tmp/resolv.conf
# This is installed by host.setDNS.sh on the host
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

