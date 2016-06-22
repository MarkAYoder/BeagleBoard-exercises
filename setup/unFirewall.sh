#!/bin/bash
# Run on bone to only accept from a few IP ranges
# Set up firewall to reject all but 317.112.*.* and 192.168.7.*
iptables --policy INPUT ACCEPT
iptables -D INPUT -s 137.112.41.0/24 -j ACCEPT
iptables -D INPUT -s 192.168.7.0/24 -j ACCEPT
iptables -D INPUT -s 10.0.4.0/24 -j ACCEPT
# Open web server to all addresses
iptables -D INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -D INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# Switch -A to -D to delete rule
# iptables -D INPUT -s 192.168.7.0/24 -j ACCEPT
