#!/bin/bash
# This copies the files need to run a new kernel from the SD card to the eMMC
# Run this on the BeagleBone Black
# Here's what's copied
# /boot/uImage
# /lib/modules/3.8.13-bone19
# /lib/firmware

# First mount the eMMC
eMMC=/media/eMMCp2
mkdir -p $eMMC
mount /dev/mmcblk1p2 $eMMC

