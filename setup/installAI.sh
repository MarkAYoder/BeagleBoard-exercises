#!/bin/bash
# Things to do the setup an AI

if ! id | grep -q root; then
        echo "must be run as root"
        exit
fi

cp ~/repos/bb-customizations/suite/buster/debian/86-rpmsg-noroot.rules /etc/udev/rules.d

echo Please reboot
