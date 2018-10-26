#!/bin/bash
# Mount a directory from the host to a vbox client
# From: https://helpdeskgeek.com/virtualization/virtualbox-share-folder-host-guest/
# 1.  Make sure "Guest Additions CD image" has been run
# 2.  Go to Shared Folders:Shared Folders Setting
# 3.  Click Add New Shared Folder
# 4.  Navigat Folder Path: to desired folder on host
# 5.  Enter a Folder Name and remember it. I used 'ece434'_dir
# 6.  Create a mount point.  I put it in my home directory
cd
DIR=ece434
mkdir $DIR
# 7.  Mount it.  'ece434_dir' is the name 
sudo mount -t vboxsf ece434_dir $DIR
ls $DIR
# 8.  Use umount to unmount
#  umount $DIR
