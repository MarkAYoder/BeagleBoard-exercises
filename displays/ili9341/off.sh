#!/bin/sh
# From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83

# Connect the display before running this.

sudo bash << EOF
    # remove the framebuffer modules
    rmmod --force fb_ili9341
    rmmod --force fbtft
    rmmod --force fbtft_device

    # unexport poins 49 and 57 so the framebuffer can use them
    echo 49 > /sys/class/gpio/unexport # RESET - V14 - GP0_PIN4
    echo 57 > /sys/class/gpio/unexport # D/C - U16 - GP0_PIN3
    # echo 113 > /sys/class/gpio/unexport # RESET - V14 - GP0_PIN4
    # echo 116 > /sys/class/gpio/unexport # D/C - U16 - GP0_PIN3

    # Turn of chip select:  H18 is cs 0,  C18 is cs 1
    echo 29 > /sys/class/gpio/unexport # CS - H18
    # echo 7 > /sys/class/gpio/unexport # CS - C18
        
EOF
