#!/bin/bash
# This script cleans up things set by the install script

hostAddr=192.168.7.1
beagleAddr=192.168.7.2

ssh root@$beagleAddr "mv /etc/resolv.conf.orig /etc/resolv.conf"
ssh root@$beagleAddr "/sbin/route del default"

