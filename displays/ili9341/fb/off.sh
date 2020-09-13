#!/bin/sh
# From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83

sudo bash << EOF
    # remove the framebuffer modules
    if lsmod | grep -q 'fbtft_device ' ; then rmmod fbtft_device;  fi
    if lsmod | grep -q 'fb_ili9341 '   ; then rmmod --force fb_ili9341;    fi
    if lsmod | grep -q 'fbtft '        ; then rmmod --force fbtft;         fi

    # Turn off LED
    ./LCD-backlight.py 0
        
EOF
