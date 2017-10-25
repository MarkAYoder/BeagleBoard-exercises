#!/bin/bash
# Goes to rcn-ee to list current images
# Run without parameter to list what available
# imageList.sh 2017-05-14 to get the 2017-05-14 iot image
SITE=https://rcn-ee.com/rootfs/bb.org/testing 
RELEASE=stretch-iot
VERSION=9.2
if [ "$1" == "" ]; then
	curl -s $SITE/ | sed -n '/^$/!{s/<[^>]*>//g;p;}' | awk -F/ '{print $1}'
	echo $SITE
elif [ "$1" == "web" ]; then
	gnome-open $SITE
else
	echo $1
	cd ~/BeagleBoard/Images
	    URL=$SITE/$1/$RELEASE/bone-debian-$VERSION-iot-armhf-$1-4gb.img.xz
	    wget $URL.sha256sum
# Check to see we we found anything, if so, wget the rest of the files.
# If not, list what you did find.
	    if [ $? -eq 0 ]
	    then	# Success
		time wget $URL
	    else
		echo -e "\n\e[91m$1: not found\e[0m\n"
		curl -s $SITE/$1/ | sed -n '/^$/!{s/<[^>]*>//g;p;}' | awk -F/ '{print $1}'
		curl -s $SITE/$1/$RELEASE/ | sed -n '/^$/!{s/<[^>]*>//g;p;}' | awk -F/ '{print $1}'
	    fi
fi
