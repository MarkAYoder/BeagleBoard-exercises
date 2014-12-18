#!/bin/bash
# This sets things up for runing the LEDstring
# 1. enables SPI0 via device tree
# 2. inserts the lpd8806 kernel module
# 3. See http://elinux.org/ECE497_SPI_Project for wiring.

export STRING_LEN=320

# Enable SPI0
echo BB-SPIDEV0 > /sys/devices/bone_capemgr.*/slots

# Insert module

sleep 1	# Seems to hang if this isn't here.
insmod driver/lpd8806.ko string_len=$STRING_LEN
