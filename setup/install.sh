#!/bin/bash
# Here are the extra things I install on the bone
# --Mark
# 20-Aug-2013
set -e
BONE=192.168.7.2
BONE_NAME=yoder-black-bone

if [ 1 == 0 ] ; then
sh-copy-id root@$BONE
DATE=`date`
ssh root@$BONE "date -s \"$DATE\""
ssh root@$BONE "echo $BONE_NAME > /etc/hostname"
ssh root@$BONE "opkg update"

ssh root@$BONE "git config --global user.name \"Mark A. Yoder\""
ssh root@$BONE "git config --global user.email Mark.A.Yoder@Rose-Hulman.edu"
scp -r .ssh root@BONE:.
ssh root@$BONE "git clone git@github.com:MarkAYoder/BeagleBoard-exercises.git exercises"

ssh root@$BONE "cp exercises/.bashrc ."
ssh root@$BONE "ln -s /var/lib/cloud9 ."
fi

ssh root@$BONE "rm /etc/localtime"
ssh root@$BONE "ln -s /usr/share/zoneinfo/America/New_York /etc/localtime"

