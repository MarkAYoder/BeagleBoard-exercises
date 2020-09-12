#!/bin/sh
# From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83

export FRAMEBUFFER=/dev/fb0

# Display an image
sudo fbi -noverbose -T 1 -a tux.png
# Cycle between several images
sudo fbi -t 5 -blend 1000 -noverbose -T 1 -a Matthias.jpg Malachi.jpg Alan.jpg Louis.jpg

# Play a movie
export SDL_VIDEODRIVER=fbcon 
export SDL_FBDEV=/dev/fb0

mplayer -vf-add rotate=4 -framedrop hst_1.mpg

# Look at the framebuffer settings
fbset