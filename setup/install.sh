#!/bin/bash
# Here are the extra things I install on the bone.
# Run this on the host computer with the Black Bone attached
#  via USB
# --Mark
# 20-Aug-2013
set -e
BONE=${1:-192.168.7.2}
BONE_NAME=yoder-debian-bone

# Set the date to that of the host computer
DATE=`date`
ssh root@$BONE "date -s \"$DATE\""

#scp -r ssh root@$BONE:.ssh

# Copy local copy of exercises to bone and then pull
echo rsyncing exercises, this will take about 40 seconds
time rsync -azq --exclude "*.o" --exclude "*.ko" --exclude esc-media --exclude c6run_build --exclude ssh ../../exercises root@$BONE:.

# echo rsyncing beaglebone-cookbook, this will take about 2 seconds
# time rsync -azq ../../beaglebone-cookbook root@$BONE:.
# time rsync -azq ../../exploringBB root@$BONE:.
# time rsync -azq ../../libsoc root@$BONE:.

ssh root@$BONE "
# Set the network name of the board
echo $BONE_NAME > /etc/hostname

# Turn off messages that appeard when you login
mv /etc/issue.net /etc/issue.net.orig

# vi settings
echo 'syntax on' >>~/.vimrc

# Set up github
git config --global user.name \"Mark A. Yoder\"
git config --global user.email Mark.A.Yoder@Rose-Hulman.edu
git config --global push.default simple
git config --global color.ui true
git config --global credential.helper \"cache --timeout=14400\"
# Fix postBuffer size
# cd beaglebone-cookbook/.git
# mv config config.orig
# sed 's/	postBuffer = 524288000//' config.orig > config
# cd

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s --backup=numbered exercises/setup/bashrc .bashrc
# ln -s --backup=numbered exercises/setup/x11vncrc .x11vncrc

# Set the default sound card to NOT be HDMI
ln -s --backup=numbered exercises/setup/asoundrc .asoundrc

# Set the time zone to Indiana
timedatectl set-timezone America/Indiana/Indianapolis

# Set language
export LANG=en_US.UTF-8

# Turn off cape-bone-proto
# sed -i -e 's:CAPE=cape-bone-proto:#CAPE=cape-bone-proto:g' /etc/default/capemgr

# Make socket.io appear where others can use it
if [ ! -e /usr/local/lib/node_modules/socket.io ] ; then
	cd /usr/local/lib/node_modules/
	ln -s bonescript/node_modules/socket.io/ .
	ln -s bonescript/node_modules/i2c/ .
	ln -s bonescript/node_modules/serialport/ .
fi

# Turn off some services
cd /etc/init.d/
mkdir -p hide
mv apache2 hide

# Set up boneServer to run at boot time
# cp ~/exercises/realtime/boneServer.service /lib/systemd/system
# systemctl start boneServer.service
# systemctl enable boneServer.service

# cd /etc/gdm
# mv custom.conf custom.conf.orig
# sed s/TimedLoginEnable=true/TimedLoginEnable=false/ custom.conf.orig > custom.conf

# Add Wheezy backport, Jessie and Sid to apt-get
# Make Wheezy the default
cd /etc/apt/sources.list.d
mkdir hide
cd hide
echo \"deb http://ftp.us.debian.org/debian/ wheezy-backports main\" > wheezy-backports.list
echo \"deb http://ftp.us.debian.org/debian/ jessie main contrib non-free\" > jessie.list
echo \"deb http://ftp.us.debian.org/debian/ stretch main contrib non-free\" > stretch.list
echo \"#deb-src http://ftp.us.debian.org/debian/ stretch main contrib non-free\" >> stretch.list
echo \"deb http://ftp.us.debian.org/debian/ sid main contrib non-free\" > sid.list
# echo \"APT::Default-Release \\"\"stable\\"\";\" > /etc/apt/apt.conf.d/local
"
exit

# Load Full Screen Mario
# git clone https://github.com/Diogenesthecynic/FullScreenMario.git
# cd exercises/realtime
# ln -s ~/FullScreenMario .
"
