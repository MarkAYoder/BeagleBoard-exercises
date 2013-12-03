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

# Update the package manager
# ssh root@$BONE "opkg update"

# Set up DNS on bone
./host.setDNS.sh
scp -r .ssh root@$BONE:.
fi

################
ssh root@$BONE "
# Set the network name of the board
echo $BONE_NAME > /etc/hostname

# Clone the ECE497 exercises from github
git config --global user.name \"Mark A. Yoder\"
git config --global user.email Mark.A.Yoder@Rose-Hulman.edu
git config --global color.ui true
git clone git@github.com:MarkAYoder/BeagleBoard-exercises.git exercises

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s exercises/setup/bashrc .bashrc
ln -s exercises/setup/x11vncrc .x11vncrc
cd /etc/gdm
mv custom.conf custom.conf.orig
sed s/TimedLoginEnable=true/TimedLoginEnable=false/ custom.conf.orig > custom.conf

# Put a symbolic link in Cloud 9 so it will see the exercises
cd /var/lib/cloud9; ln -s ~/exercises .

# Set up boneServer to run at boot time
cp ~/exercises/realtime/boneServer.service /lib/systemd/system
systemctl start boneServer
systemctl enable boneServer

# Set the time zone to Indiana
rm /etc/localtime
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# Run if ssh is refusing connections
# rm /etc/dropbear/dropbear_rsa_host_key
# reboot
"
################
