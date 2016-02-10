#!/bin/bash
# Run on bone to only accept from a few IP ranges
# Set up firewall to reject all but 317.112.*.* and 192.168.7.*
iptables --policy INPUT DROP
iptables -A INPUT -s 137.112.0.0/16 -j ACCEPT
iptables -A INPUT -s 192.168.7.0/24 -j ACCEPT
iptables -A INPUT -s 10.0.4.0/24 -j ACCEPT
# Switch -A to -D to delete rule
# iptables -D INPUT -s 192.168.7.0/24 -j ACCEPT
