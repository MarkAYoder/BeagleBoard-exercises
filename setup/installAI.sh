#!/bin/bash
# Things to do the setup an AI

if ! id | grep -q root; then
        echo "must be run as root"
        exit
fi

groupadd remoteproc
usermod -a -G remoteproc debian

cp /home/debian/exercises/setup/86-remoteproc-noroot.rules /etc/udev/rules.d

echo Please reboot
