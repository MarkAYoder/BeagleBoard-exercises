#!/bin/sh
# From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83

# From: https://github.com/notro/fbtft/wiki/Framebuffer-use
# This is for controlling the framebuffer
sudo apt install fbset

# Get framebuffer imageviewer
sudo apt install fbi

# Load if using JavaScript mmap
sudo npm install -g mmap.js

# Get some images to work on
wget https://kernel.org/theme/images/logos/tux.png
wget http://www.rose-hulman.edu/InstituteBrandResources/RH_Graphic_Secondary.zip

# Get mplayer to play some video
sudo apt install mplayer
 
 # Get some sample video
wget http://hubblesource.stsci.edu/sources/video/clips/details/images/hst_1.mpg
wget http://www.koeniglich.de/pics/RedsNightmare.mpg

# This will let us add text to the images
sudo apt install imagemagick

# 1.  Solder the two (2) JST SH 6 Wire Assemblies to the 2.4 TFT Breakout with: 

# JST Pin	TFT Pin
# 1-1 GND
# 1-2	Vin
# 1-3	MOSI
# 1-4	MISO
# 1-5	CLK
# 1-6	CS
# 2-5	D/C
# 2-6	RST

# 2.  Connect	JST-1 to S1.1 connector on BeagleBone Blue.

# 3.  Connect JST-2 to GP0 connector on BeagleBone Blue.

sudo apt install python-pygame
