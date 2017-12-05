#!/bin/bash
# This sets things up for runing the LEDstring
# 1. enables SPI0 via device tree
# 2. inserts the lpd8806 kernel module
# 3. See http://elinux.org/ECE497_SPI_Project for wiring.

config-pin P9_18 spi
config-pin P9_22 spi_sclk

# Make it so sudo isn't needed
sudo chown root:gpio /sys/firmware/lpd8806/device/*

# config-pin P9_30 spi
# config-pin P9_31 spi_sclk

export STRING_LEN=320

# Enable SPI0 - No longer needed
# echo BB-SPIDEV1 > /sys/devices/platform/bone_capemgr/slots

# Insert module

sleep 1	# Seems to hang if this isn't here.
sudo insmod driver/lpd8806.ko string_len=$STRING_LEN
