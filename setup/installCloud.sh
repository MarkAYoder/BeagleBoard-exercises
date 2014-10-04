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

# Set up github
git config --global user.name \"Mark A. Yoder\"
git config --global user.email Mark.A.Yoder@Rose-Hulman.edu
git config --global color.ui true

# Get Beagle things
git clone git@github.com:MarkAYoder/BeagleBoard-exercises.git exercises

# Copy the .bashrc and .x11vncrc files from github so bash and x11vnc will use them
ln -s --backup=numbered exercises/setup/bashrc .bashrc

"
