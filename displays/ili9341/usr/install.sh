# From: https://learn.adafruit.com/user-space-spi-tft-python-library-ili9341-2-8/usage
sudo apt update
sudo apt install build-essential python-dev python-smbus python-pip python-imaging python-numpy
sudo pip install Adafruit_BBIO

cd ~
git clone https://github.com/adafruit/Adafruit_Python_ILI9341.git
cd Adafruit_Python_ILI9341
sudo python setup.py install

sudo pip install spidev
