#!/bin/bash
# Here are the extra things I install on the bone for the ASEE workshop.
# Run this on the host computer with the BeagleBone Blue attached via USB
# --Mark
# 6-June-2017

ln -s /opt/source/Robotics_Cape_Installer/ .
ln -s /opt/source/rcpy/ .

sudo apt update
sudo apt install python3-numpy

git clone https://github.com/mcdeoliveira/pyctrl.git

cd ../pyctrl
sudo python3 setup.py install

EXAMPLES=/var/lib/cloud9/examples/robot
mkdir -p $EXAMPLES
cd $EXAMPLES
ln -s ~/asee python