#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# From: https://www.pygame.org/wiki/GettingStarted

apt install python3-pygame python3-tk libopenjp2-7 # 
pip3 install requests  pillow      # 6m22

echo "mode \"320x240\"
    geometry 320 240 320 240 16
    timings 0 0 0 0 0 0 0
    rgba 5/11,6/5,5/0,0/0
endmode
" >> /etc/fb.modes
