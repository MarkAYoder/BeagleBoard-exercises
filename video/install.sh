# From: http://www.egr.msu.edu/classes/ece480/capstone/fall13/group04/docs/briapp.pdf
apt-get install v4l-utils
git clone https://github.com/derekmolloy/boneCV.git
apt-get install libv4l-dev
gcc -lv4l2 -o grabber grabber.c
apt-get install graphicsmagick

npm install -g v4l2camera
npm install -g gm

