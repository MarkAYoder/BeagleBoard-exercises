#!/bin/bash
# Here are the extra things I install on the bone for the ASEE workshop.
# Run this on the host computer with the BeagleBone Blue attached via USB
# --Mark
# 25-May-2017

# git clone https://github.com/mcdeoliveira/Robotics_Cape_Installer.git
# git clone https://github.com/mcdeoliveira/rcpy
# git clone https://github.com/mcdeoliveira/ctrl.git

git clone https://github.com/mcdeoliveira/pyctrl.git

ln -s /opt/source/Robotics_Cape_Installer/ .
ln -s /opt/source/rcpy/ .

sudo apt update
sudo apt install python3-numpy

# cd Robotics_Cape_Installer
# git checkout devel
# sudo ./install.sh

# cd ../rcpy
# sudo python3 setup.py install

cd ../pyctrl
sudo python3 setup.py install
