export FRAMEBUFFER=/dev/fb0

apt install fbi
 
wget https://kernel.org/theme/images/logos/tux.png
wget http://www.rose-hulman.edu/InstituteBrandResources/RH_Graphic_Secondary.zip

fbi -noverbose -T 1 -a tux.png
fbi -t 5 -blend 1000 -noverbose -T 1 -a Matthias.jpg Malachi.jpg Alan.jpg Louis.jpg
# This worked

apt install mplayer
 
wget http://hubblesource.stsci.edu/sources/video/clips/details/images/hst_1.mpg
wget http://www.koeniglich.de/pics/RedsNightmare.mpg

SDL_VIDEODRIVER=fbcon SDL_FBDEV=/dev/fb0 mplayer --vf-add=rotate=2 -vo sdl -framedrop hst_1.mpg

# If you get an error about the size being wrong install the following.
# From: https://github.com/notro/fbtft/wiki/Framebuffer-use
apt install fbset
fbset
# Take the output of fbset and append it to /etc/fd.modes
