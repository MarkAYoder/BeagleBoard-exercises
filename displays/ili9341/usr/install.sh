# From: https://learn.adafruit.com/user-space-spi-tft-python-library-ili9341-2-8/usage
# Now works for python3
sudo apt update
# sudo apt install build-essential python-dev python-smbus 
sudo apt install python-pip python-imaging python-numpy
# sudo pip3 install Adafruit_BBIO

git clone https://github.com/adafruit/Adafruit_Python_ILI9341.git
cd Adafruit_Python_ILI9341
sudo python3 setup.py install       # 39 seconds

# https://stackoverflow.com/questions/23970006/using-pillow-with-python-3
sudo apt install zlib1g-dev libjpeg62-turbo-dev     # 31 seconds
# sudo apt-get install libtiff4-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.5-dev tk8.5-dev python-tk
sudo pip3 install pillow        # 6 minutes

# sudo pip3 install spidev
