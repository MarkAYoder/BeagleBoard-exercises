#!/bin/bash
# This sets things up for runing the LEDstring
# 1. enables SPI0 via device tree
# 2. inserts the lpd8806 kernel module

export STRING_LEN=320

# Enable SPI0
echo BB-SPI0 > /sys/devices/bone_capemgr.*/slots

# Insert module

sleep 1	# Seems to hang if this isn't here.
insmod driver/lpd8806.ko string_len=$STRING_LEN
