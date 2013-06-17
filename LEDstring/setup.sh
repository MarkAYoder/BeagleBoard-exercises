#!/bin/bash
# This sets things up for runing the LEDstring
# 1. enables SPI0 via device tree
# 2. inserts the lpd8806 kernel module

# Enable SPI0
if [ ! -e /lib/firmware/BB-SPI0-01-00A0.dtbo ] 
then
	echo Copying
	cp driver/BB-SPI0-01-00A0.dtbo /lib/firmware
fi
echo BB-SPI0-01 > /sys/devices/bone_capemgr.*/slots

# Insert module
cd driver
sleep 1	# Seems to hang if this isn't here.
insmod lpd8806.ko


