# Here's how to install The Matrix
# From: https://www.boldport.com/products/the-matrix/
git clone https://github.com/threebytesfull/matrix-pi.git
sudo pip uninstall distribute
sudo apt install build-essential python-dev python-pip python-smbus # python3-smbus
sudo pip install setuptools_scm
sudo pip install --upgrade setuptools
sudo pip install the_matrix
i2cdetect -y -r 2  # I wired to i2c bus 2.  P9_19 - SCL, P9_20 - SDA
# The library defaults to bus 1, use -b for bus 2
the_matrix_identify -b 2
the_matrix_leds -b 2 5 10
the_matrix_scrolltest -b This is a test


# This is of displaying the current holiday
sudo npm install -g --save node-holidayapi
