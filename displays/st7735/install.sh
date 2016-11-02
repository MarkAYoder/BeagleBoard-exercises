# Nice instructions: http://beagleboard.org/project/bbb-lcd-fbtft-prebuilt/
# Driver appears to be already installed.
modprobe fbtft_device busnum=2 name=adafruit18 debug=7 verbose=3 gpios=dc:7,reset:20
# The Adafruit LCD (https://www.adafruit.com/products/358) is 128x160, so it may work

apt install fbi
 
wget https://kernel.org/theme/images/logos/tux.png
fbi -d /dev/fb0 -T 1 -a tux.png
