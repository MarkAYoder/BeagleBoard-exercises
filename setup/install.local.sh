#!/bin/bash
# Here are the extra things I install on the bone.
# Run this on the Bone
# --Mark
# 18_dec-2019

set -e
BONE=${1:-192.168.7.2}
BONE_NAME=bone
USER=debian

# Work from home directory
cd

echo
echo rsyncing exercises, this will take a couple of minutes
echo
# git clone https://github.com/MarkAYoder/BeagleBoard-exercises.git exercises --depth=1

# vi settings
echo 'syntax on' >>~/.vimrc

# Set up github
ln -s --backup=numbered ~/exercises/setup/gitconfig .gitconfig

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s --backup=numbered ~/exercises/setup/bashrc .bashrc

# Set the default sound card to NOT be HDMI
ln -s --backup=numbered ~/exercises/setup/asoundrc .asoundrc

# Set language
export LANG=en_US.UTF-8

# Now do root things

# Disable hdmi video to get access to PRU pins on P8
# mv /boot/uEnv.txt /boot/uEnv.txt.orig
# sed 's/#disable_uboot_overlay_video=1/disable_uboot_overlay_video=1/' < /boot/uEnv.txt.orig > /boot/uEnv.txt

# Turn off messages that appeard when you login
sudo mv /etc/issue /etc/issue.orig
sudo mv /etc/issue.net /etc/issue.net.orig
sudo mv /etc/motd /etc/motd.orig

# Set the time zone to Indiana
timedatectl set-timezone America/Indiana/Indianapolis
