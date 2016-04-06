#!/bin/bash
set -e
# Beaglebone
BUS=2
DISPLAY_RGB_ADDR=0x62
DISPLAY_TEXT_ADDR=0x3e

# i2cdump -y $BUS $DISPLAY_RGB_ADDR
# i2cget -y $BUS $DISPLAY_RGB_ADDR 0

i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x3a
sleep 0.05
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x0f
sleep 0.05
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x01
sleep 0.05
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x07
sleep 0.05

i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x01
sleep 0.05
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x02
sleep 0.05
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x07
sleep 0.05
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x0f
sleep 0.05


# i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x01  # Clear display
# sleep 0.05
# i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x04  # display on, no cursor
# sleep 0.05
# i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x80 0x28  # 2 lines
# sleep 0.05
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x40 0xe1
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x40 0x62
i2cset -y $BUS $DISPLAY_TEXT_ADDR 0x40 0x42

i2cset -y $BUS $DISPLAY_RGB_ADDR 0 0
i2cset -y $BUS $DISPLAY_RGB_ADDR 1 0
i2cset -y $BUS $DISPLAY_RGB_ADDR 0x08 0xaa
i2cset -y $BUS $DISPLAY_RGB_ADDR 4   0  # R
i2cset -y $BUS $DISPLAY_RGB_ADDR 3 128  # G
i2cset -y $BUS $DISPLAY_RGB_ADDR 2   0  # B
