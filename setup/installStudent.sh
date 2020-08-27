#!/bin/bash
# Here are the extra things I install on the bone.
# Run this on the host computer with the BeagleBone Black attached via USB
# --Mark
# 20-Aug-2013
# 23-Mar-2017, Adjusted for debian login
# 27-Aug-2020, Made student version
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
BONE_NAME=bone
USER=debian

# Set the date to that of the host computer
DATE=`date`
ssh root@$BONE "date -s \"$DATE\""

# Do things are debian first.

ssh $USER@$BONE "
# Set up root
ln -s / root
mkdir host

# Set up bin/
cd ~/bin
ln -s /opt/scripts/device/bone/show-pins.pl .
cd

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s --backup=numbered exercises/setup/bashrc .bashrc
ln -s --backup=numbered exercises/setup/vimrc .vimrc

# Set the default sound card to NOT be HDMI
ln -s --backup=numbered exercises/setup/asoundrc .asoundrc

# Set language
export LANG=en_US.UTF-8

# Add mouse to tmux
# git clone https://github.com/gpakosz/.tmux
"

# Now do root things
ssh root@$BONE "

# Disable hdmi video to get access to PRU pins on P8
mv /boot/uEnv.txt /boot/uEnv.txt.orig
sed 's/#disable_uboot_overlay_video=1/disable_uboot_overlay_video=1/' < /boot/uEnv.txt.orig > /boot/uEnv.txt

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

"

exit
