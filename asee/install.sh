#!/bin/bash
# Here are the extra things I install on the bone for the ASEE workshop.
# Run this on the host computer with the BeagleBone Blue attached via USB
# --Mark
# 25-May-2017

git clone https://github.com/mcdeoliveira/Robotics_Cape_Installer.git
git clone https://github.com/mcdeoliveira/rcpy
git clone https://github.com/mcdeoliveira/ctrl.git

sudo apt update
sudo apt install less
sudo apt install python3-setuptools python3-dev python3-numpy

cd Robotics_Cape_Installer
git checkout devel
sudo ./install.sh

cd ../rcpy
sudo python3 setup.py install
