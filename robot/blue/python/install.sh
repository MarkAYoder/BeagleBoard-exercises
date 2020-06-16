#!/bin/bash
# Here are the extra things I install on the bone for the ASEE workshop.
# Run this on the host computer with the BeagleBone Blue attached via USB
# --Mark
# 6-June-2017

ln -s /opt/source/Robotics_Cape_Installer/ .
ln -s /opt/source/rcpy/ .
ln -s /opt/source/pyctrl/ .

EXAMPLES=/var/lib/cloud9/examples/robot
mkdir -p $EXAMPLES
cd $EXAMPLES
ln -s ~/asee python
