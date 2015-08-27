#!/bin/bash
# Here are the things I install on cloud machines
# --Mark
# 4-Oct-2014
set -e
BONE=ec2
BONE_NAME=yoder-aws-cloud

ssh $BONE "
apt-get update
apt-get install git
apt-get dist-upgrade

# Set up github
git config --global user.name \"Mark A. Yoder\"
git config --global user.email Mark.A.Yoder@Rose-Hulman.edu
git config --global color.ui true
git config --global push.default simple
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'

# Get Beagle things
mkdir BeagleBoard
git clone https://github.com/MarkAYoder/BeagleBoard-exercises.git exercises

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s --backup=numbered BeagleBoard/exercises/setup/bashrc .bashrc

"
