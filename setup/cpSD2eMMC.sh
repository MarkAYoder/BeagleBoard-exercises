#!/bin/bash
# This copies the files need to run a new kernel from the SD card to the eMMC
# Run this on the BeagleBone Black
# Here's what's copied
# /boot/uImage
# /lib/modules/3.8.13-bone19
# /lib/firmware

# First mount the eMMC
eMMC=/media/eMMCp2
MODULES=3.8.13-bone20.2
mkdir -p $eMMC
mount /dev/mmcblk1p2 $eMMC

echo Copying firmware
cd $eMMC/lib
mv firmware firmware.orig
cp -r /lib/firmware .

echo Copying modules
cp -r /lib/modules/$MODULES $eMMC/lib/modules

echo Copying uImage
cd $eMMC/boot
cp /boot/uImage-$MODULES $eMMC/boot
mv uImage uImage_back
ln -s uImage-$MODULES uImage

echo Cleaning up
cd
sync
# umount $eMMC


