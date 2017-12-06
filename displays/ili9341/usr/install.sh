# From: https://learn.adafruit.com/user-space-spi-tft-python-library-ili9341-2-8
# Wire as shown, EXCEPT:

# D/C goes to P9_26
# RESET goes to P9_27
config-pin P9_26 gpio
config-pin P9_27 gpio

# SPI_PORT 1 - Adafruit instructions
# config-pin P9_17 spi_cs
# config-pin P9_18 spi
# config-pin P9_22 spi_scl

# SPI_PORT 2
# CS   to P9_28
# MOSI to P9_30
# SCLK to P9_31
config-pin P9_28 spi_cs
config-pin P9_30 spi
config-pin P9_31 spi_sclk


# From: https://learn.adafruit.com/user-space-spi-tft-python-library-ili9341-2-8/usage
sudo apt-get update
sudo apt-get install build-essential python-dev python-smbus python-pip python-imaging python-numpy
sudo pip install Adafruit_BBIO

cd ~
git clone https://github.com/adafruit/Adafruit_Python_ILI9341.git
cd Adafruit_Python_ILI9341
sudo python setup.py install
