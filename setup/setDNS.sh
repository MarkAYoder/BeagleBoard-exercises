#!/bin/bash
# These are the commands to run on the host so the Beagle
#  can access the Internet through the USB connection.
# Run ./ipForward.sh the first time. It will set up the host.
# Run this script if the host is already set up.
# Inspired by http://thoughtshubham.blogspot.com/2010/03/internet-over-usb-otg-on-beagleboard.html

hostAddr=192.168.7.1
beagleAddr=${1:-192.168.7.2}

# Save the /etc/resolv.conf on the Beagle in case we mess things up.
ssh root@$beagleAddr "mv -n /etc/resolv.conf /etc/resolv.conf.orig"
# Create our own resolv.conf
cat - << EOF > /tmp/resolv.conf
# This is installed by ./setDNS.sh on the host
# Mark A. Yoder, 25-FEB-2014
search rose-hulman.edu dhcp.rose-hulman.edu wlan.rose-hulman.edu

EOF

# Look up the nameserver of the host and add it to our resolv.conf
# From: http://askubuntu.com/questions/197036/how-to-know-what-dns-am-i-using-in-ubuntu-12-04
nmcli dev list | grep IP4.DNS | sed 's/IP4.DNS\[.\]:/nameserver/' >> /tmp/resolv.conf
scp /tmp/resolv.conf root@$beagleAddr:/etc

# Tell the beagle to use the host as the gateway.
ssh root@$beagleAddr "/sbin/route add default gw $hostAddr" || true

