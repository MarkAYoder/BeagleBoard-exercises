#!/bin/bash
# Goes to rcn-ee to list current images
# Run without parameter to list what available
# imageList.sh 2017-05-14 to get the 2017-05-14 iot image
SITE=https://rcn-ee.com/rootfs/bb.org/testing/ 
RELEASE=stretch-iot
if [ "$1" == "" ]; then
	google-chrome $SITE
	curl $SITE | sed -n '/^$/!{s/<[^>]*>//g;p;}' 
	echo $SITE
else
	echo $1
	cd ~/BeagleBoard/Images
	     wget $SITE/$1/$RELEASE/bone-debian-$RELEASE-armhf-$1-4gb.bmap
	     wget $SITE/$1/$RELEASE/bone-debian-$RELEASE-armhf-$1-4gb.img.xz.sha256sum
	time wget $SITE/$1/$RELEASE/bone-debian-$RELEASE-armhf-$1-4gb.img.xz
fi
