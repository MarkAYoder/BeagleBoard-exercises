#!/bin/sh
# From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83

# Connect the display before running this.

export GPIO=/sys/class/gpio
export OCP=/sys/devices/platform/ocp
export LED=49
export RESET=113    # RESET - V14 - GP0_6
export DC=116       # D/C - U16 - GP0_3
export CS=29        # CS - H18

sudo bash << EOF
    # remove the framebuffer modules
    if lsmod | grep -q 'fbtft_device ' ; then rmmod fbtft_device;  fi
    if lsmod | grep -q 'fb_ili9341 '   ; then rmmod fb_ili9341;    fi
    if lsmod | grep -q 'fbtft '        ; then rmmod fbtft;         fi

    # Turn off LED
    if [ -d $GPIO/gpio$LED    ]
    then 
        echo 0 > $GPIO/gpio$LED/value
        echo $LED    > $GPIO/unexport
    fi
        
EOF
