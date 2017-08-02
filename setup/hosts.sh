#!/bin/bash
# Updates /etc/hosts
cat - << EOF >> /etc/hosts

# Mandi hosts
192.168.7.1     host
192.168.8.1     bone
10.8.7.185      bone2
14.139.34.32    think
137.112.41.35   office

EOF
