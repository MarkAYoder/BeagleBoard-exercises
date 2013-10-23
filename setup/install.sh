#!/bin/bash
# Here are the extra things I install on the bone.
# Run this on the host computer with the Black Bone attached
#  via USB
# --Mark
# 20-Aug-2013
set -e
BONE=192.168.7.2
BONE_NAME=yoder-black-bone

if [ 1 == 1 ] ; then
# Make it so ssh will run without a password
ssh-copy-id root@$BONE

# Set the date to that of the host computer
DATE=`date`
ssh root@$BONE "date -s \"$DATE\""

# Set the network name of the board
ssh root@$BONE "echo $BONE_NAME > /etc/hostname"

# Update the package manager
# ssh root@$BONE "opkg update"
fi

# Set up DNS on bone
./host.setDNS.sh
scp -r .ssh root@$BONE:.

# Clone the ECE497 exercises from github
ssh root@$BONE "git config --global user.name \"Mark A. Yoder\""
ssh root@$BONE "git config --global user.email Mark.A.Yoder@Rose-Hulman.edu"
ssh root@$BONE "git clone git@github.com:MarkAYoder/BeagleBoard-exercises.git exercises"

# Copy the .bashrc file from github so bash will use it
ssh root@$BONE "cp exercises/.bashrc ."

# Put a symbolic link in Cloud 9 so it will see the exercises
ssh root@$BONE "cd /var/lib/cloud9; ln -s ~/exercises ."

# Set the time zone to Indiana
ssh root@$BONE "rm /etc/localtime"
ssh root@$BONE "ln -s /usr/share/zoneinfo/America/New_York /etc/localtime"

