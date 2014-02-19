#!/bin/bash
# Here are the extra things I install on the bone.
# Run this on the host computer with the Black Bone attached
#  via USB
# --Mark
# 20-Aug-2013
set -e
BONE=192.168.7.2
BONE_NAME=yoder-debian-bone

# Grow the partition to use whole card
if [ 1 == 0 ] ; then
ssh root@$BONE /opt/scripts/tools/grow_partition.sh
reboot
fi

# Make it so ssh will run without a password
ssh-copy-id root@$BONE

# Set the date to that of the host computer
DATE=`date`
ssh root@$BONE "date -s \"$DATE\""

# Update the package manager
# ssh root@$BONE "opkg update"

# Set up DNS on bone
./host.setDNS.sh
scp ssh/* root@$BONE:.ssh

# Copy local copy of exercises to bone and then pull
echo rsyncing exercises, this will take about 40 seconds
time rsync -az --progress --exclude "*.o" --exclude esc-media --exclude c6run_build ../../exercises root@bone:.

################
ssh root@$BONE "
# Set the network name of the board
echo $BONE_NAME > /etc/hostname

# Set up github
git config --global user.name \"Mark A. Yoder\"
git config --global user.email Mark.A.Yoder@Rose-Hulman.edu
git config --global color.ui true
# cd exercises
# git pull
# cd ..

# git clone git@github.com:MarkAYoder/BeagleBoard-exercises.git exercises

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s --backup=numbered exercises/setup/bashrc .bashrc
ln -s --backup=numbered exercises/setup/x11vncrc .x11vncrc

# Put a symbolic link in Cloud 9 so it will see the exercises
if [ ! -e /var/lib/cloud9/exercises ] ; then
	cd /var/lib/cloud9
	ln -s ~/exercises .
fi

# Set the time zone to Indiana
rm /etc/localtime
ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# Turn off cape-bone-proto
sed -i -e 's:CAPE=cape-bone-proto:#CAPE=cape-bone-proto:g' /etc/default/capemgr

# Make socket.io appear where others can use it
if [ ! -e /usr/lib/node_modules/socket.io ] ; then
	cd /usr/lib/node_modules/
	ln -s bonescript/node_modules/socket.io/ .
fi
cd ~/exercises

# Set up boneServer to run at boot time
cp ~/exercises/realtime/boneServer.service /lib/systemd/system
# systemctl start boneServer
systemctl enable boneServer

# cd /etc/gdm
# mv custom.conf custom.conf.orig
# sed s/TimedLoginEnable=true/TimedLoginEnable=false/ custom.conf.orig > custom.conf
"
exit
# Run if ssh is refusing connections
# rm /etc/dropbear/dropbear_rsa_host_key
# reboot

# Load Full Screen Mario
# git clone https://github.com/Diogenesthecynic/FullScreenMario.git
# cd exercises/realtime
# ln -s ~/FullScreenMario .
"

################
