#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
# Run on bone to only accept from a few IP ranges
# Set up firewall to reject all but 317.112.*.* and 192.168.7.*
iptables --policy INPUT DROP
# Only ECE subnet
iptables -A INPUT -s 137.112.41.0/24 -j ACCEPT
# Beagle network
iptables -A INPUT -s 192.168.7.0/24 -j ACCEPT
# Home network
iptables -A INPUT -s 10.0.4.0/24 -j ACCEPT

# Allow outgoing things to come back
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Open web server to all addresses
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# Switch -A to -D to delete rule
# iptables -D INPUT -s 192.168.7.0/24 -j ACCEPT
