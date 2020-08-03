#!/bin/bash
# Fix remoteproc permissions
if ! id | grep -q root; then
        echo "must be run as root"
        exit
fi
FW='am335x-pru0-fw am335x-pru1-fw'
cd /lib/firmware
touch $FW
chown root:remoteproc $FW
chmod g+w $FW

# Set up remoteproc links
cd /dev/remoteproc/
ln -s /sys/class/remoteproc/remoteproc1 pruss-core0
ln -s /sys/class/remoteproc/remoteproc2 pruss-core1
