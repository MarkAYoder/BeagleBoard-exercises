# From: http://www.egr.msu.edu/classes/ece480/capstone/fall13/group04/docs/briapp.pdf
apt-get install v4l-utils libv4l-dev imagemagick
gcc -lv4l2 -o grabber grabber.c

# apt-get install graphicsmagick
# npm install -g v4l2camera
# npm install -g gm
# git clone https://github.com/derekmolloy/boneCV.git

# This is for exploring BeagleBone - Chapter 12
apt update
apt install libv4l-dev v4l-utils fswebcam gpicview libav-tools
# 134M and almost 2 hours to install.
apt install libopencv-core-dev
