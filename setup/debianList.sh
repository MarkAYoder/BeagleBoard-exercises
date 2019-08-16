#!/bin/bash
# Goes to https://packages.debian.org/ for current packages
# Run without parameter to list what available
SITE=https://packages.debian.org/
RELEASE=buster
if [ "$1" == "" ]; then
	google-chrome $SITE/$RELEASE/
else
	echo $1
	google-chrome $SITE/$RELEASE/$1
fi
