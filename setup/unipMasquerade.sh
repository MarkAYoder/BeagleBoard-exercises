#!/bin/bash
# These are the commands turn off ip forwarding
sudo iptables -t nat -F
sudo iptables -t nat -X
