#!/bin/bash
# Goes to rcn-ee to list current images
# Run without parameter to list what available
# imageList.sh 2017-05-14 to get the 2017-05-14 iot image
SITE=https://rcn-ee.com/rootfs/bb.org/testing 
RELEASE=stretch-iot
VERSION=9.1
if [ "$1" == "" ]; then
	curl $SITE | sed -n '/^$/!{s/<[^>]*>//g;p;}' | awk -F/ '{print $1}'
	echo $SITE
elif [ "$1" == "web" ]; then
	google-chrome $SITE
else
	echo $1
	cd ~/BeagleBoard/Images
	     URL=$SITE/$1/$RELEASE/bone-debian-$VERSION-iot-armhf-$1-4gb
	     wget $URL.bmap
	     wget $URL.img.xz.sha256sum
	time wget $URL.img.xz
fi
