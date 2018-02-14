# Here's how to install The Matrix
# From: https://www.boldport.com/products/the-matrix/
git clone https://github.com/threebytesfull/matrix-pi.git
sudo apt install python-smbus # python3-smbus
cd matrix-pi
sudo pip install the_matrix
i2cdetect -y -r 2  # I wired to i2c bus 2.  P9_19 - SCL, P9_20 - SDA
# The library defaults to bus 1.  I edited the library to use bus 2
pip show the_matrix     # This shows where pip installed the library
cd /usr/local/lib/python2.7/dist-packages/the_matrix
grep bus_ *             # Show which files need to be edited to change the bus.
# Change bus_number=1 to bus_number=2
the_matrix_identify
the_matrix_leds
the_matrix_scrolltest


# This is of displaying the current holiday
sudo npm install -g --save node-holidayapi
