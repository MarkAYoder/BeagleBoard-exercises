# This sets things up for runing the LEDstring
# 1. enables SPI0 via device tree
# 2. inserts the lpd8806 kernel module

# Enable SPI0
echo BB-SPI0-01 > /sys/devices/bone_capemgr.*/slots

# Insert module
cd driver
insmod lpd8806


