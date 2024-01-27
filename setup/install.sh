#!/bin/bash
# Here are the extra things I install on the bone.
# Run this on the host computer with the BeagleBone Black attached via USB
# --Mark
# 20-Aug-2013
# 23-Mar-2017, Adjusted for debian login
# Before running the script you need to set a root password and setup keys
#	for remote login without a password.
# Set root password
# host$ ssh debian@192.168.7.2, default password is temppwd
# bone$ sudo bash
# bone# passwd
# While logged onto the Bone as root you may need to edit /etc/shh/sshd_config
# Find the line that says "PermitRootLogin" and set it to "yes".
# Then run "systemctl restart sshd"
# Now exit twice to get back to the host machine.
# Now generate an ssh key and copy your id for remote access
# host$ ssh-keygen  (accpet the default answer to all prompts)
# host$ ssh-copy-id root@192.168.7.2
# host$ ssh-copy-id debian@192.168.7.2
# You can now ssh to the Bone either as root or debian without a password from your host.

# This is for setting up the access point: /etc/default$ echo bb-wl18xx 
set -e
BONE=${1:-192.168.7.2}
BONE=${1:-192.168.7.2}
BONE_NAME=bone
USER=debian

# Set the date to that of the host computer
DATE=`date`
ssh root@$BONE "date -s \"$DATE\""

# scp -r ssh root@$BONE:.ssh

# Do things are debian first.

# Copy local copy of exercises to bone and then pull
# echo
# echo rsyncing exercises, this will take a couple of minutes
# echo
# git git@github.com:MarkAYoder/BeagleBoard-exercises.git exercises --depth=1
# time rsync -azq --exclude "*.o" --exclude "*.ko" --exclude esc-media --exclude c6run_build --exclude ssh ../../exercises $USER@$BONE:.

# echo rsyncing beaglebone-cookbook, this will take about 2 seconds
# time rsync -azq ../../beaglebone-cookbook $USER@$BONE:.
# time rsync -azq ../../exploringBB $USER@$BONE:.
# time rsync -azq ../../libsoc $USER@$BONE:.

ssh $USER@$BONE "
# Set up root
ln -s / root
mkdir host

cd

# Set up github
ln -s --backup=numbered exercises/setup/gitconfig .gitconfig

# github for cloud9
# cd /var/lib/cloud9
# git config user.name 'Mark A. Yoder'
# git config user.email Mark.A.Yoder@beagleboard.org
# git fetch
# Use next versions branch
# git checkout v2020.08
# cd

# Fix postBuffer size
# cd beaglebone-cookbook/.git
# mv config config.orig
# sed 's/	postBuffer = 524288000//' config.orig > config
# cd

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s --backup=numbered exercises/setup/bashrc .bashrc
ln -s --backup=numbered exercises/setup/vimrc .vimrc

# Set the default sound card to NOT be HDMI
ln -s --backup=numbered exercises/setup/asoundrc .asoundrc

# Set language
export LANG=en_US.UTF-8

# Set up cloud9
# ln -s --backup=numbered /opt/cloud9/.c9 .

# Add mouse to tmux
# git clone https://github.com/gpakosz/.tmux
"

# Now do root things
ssh root@$BONE "

# Disable hdmi video to get access to PRU pins on P8
mv /boot/uEnv.txt /boot/uEnv.txt.orig
sed 's/#disable_uboot_overlay_video=1/disable_uboot_overlay_video=1/' < /boot/uEnv.txt.orig > /boot/uEnv.txt

# link to exercises
# ln -s ~$USER .

# Set the network name of the board, use the default name plus the last
#   four digits of the inet6 address.
# echo $BONE_NAME-`/sbin/ifconfig SoftAp0 | awk '/inet6/{print substr($2, length($2)-3)}'` > /etc/hostname

# Set access point password
# edit /etc/default/bb-wl18xx

# Turn off messages that appeard when you login
mv /etc/issue /etc/issue.orig
mv /etc/issue.net /etc/issue.net.orig
mv /etc/motd /etc/motd.orig

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s --backup=numbered ~$USER/exercises/setup/bashrc .bashrc
ln -s --backup=numbered ~$USER/exercises/setup/vimrc .vimrc

# Set the time zone to Indiana
timedatectl set-timezone America/Indiana/Indianapolis

# Set language
export LANG=en_US.UTF-8

# Turn off cape-bone-proto
# sed -i -e 's:CAPE=cape-bone-proto:#CAPE=cape-bone-proto:g' /etc/default/capemgr

# Make socket.io appear where others can use it
# if [ ! -e /usr/local/lib/node_modules/socket.io ] ; then
# 	cd /usr/local/lib/node_modules/
# 	ln -s bonescript/node_modules/socket.io/ .
# 	ln -s bonescript/node_modules/i2c/ .
# 	ln -s bonescript/node_modules/serialport/ .
# fi

# Turn off some services
# systemctl disable apache2

# Set up boneServer to run at boot time
# cp ~/exercises/realtime/boneServer.service /lib/systemd/system
# systemctl start boneServer.service
# systemctl enable boneServer.service

# cd /etc/gdm
# mv custom.conf custom.conf.orig
# sed s/TimedLoginEnable=true/TimedLoginEnable=false/ custom.conf.orig > custom.conf

# Add Wheezy backport, Jessie and Sid to apt-get
# Make Wheezy the default
# cd /etc/apt/sources.list.d
# mkdir hide
# cd hide
# echo \"deb http://ftp.us.debian.org/debian/ wheezy-backports main\" > wheezy-backports.list
# echo \"deb http://ftp.us.debian.org/debian/ jessie main contrib non-free\" > jessie.list
# echo \"deb http://ftp.us.debian.org/debian/ stretch main contrib non-free\" > stretch.list
# echo \"#deb-src http://ftp.us.debian.org/debian/ stretch main contrib non-free\" >> stretch.list
# echo \"deb http://ftp.us.debian.org/debian/ sid main contrib non-free\" > sid.list
# echo \"APT::Default-Release \\"\"stable\\"\";\" > /etc/apt/apt.conf.d/local

"
echo git clone git@github.com:MarkAYoder/BeagleBoard-exercises.git exercises --depth=1

# exit

# Load Full Screen Mario
# git clone https://github.com/Diogenesthecynic/FullScreenMario.git
# cd exercises/realtime
# ln -s ~/FullScreenMario .
# "
