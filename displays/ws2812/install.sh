# First install Yona-Apple's LEDscape
git clone https://github.com/Yona-Appletree/LEDscape.git

# Next get openpixel control
https://github.com/zestyping/openpixelcontrol

# Find which channels are on which pins
cd LEDscape/pru
node pinmap.js

# I see channel 0 on P9_22
# Start the opc_server
cd ..
./opc_server --config ../ws281x-may.json &

# Start a pattern
cd openpixelcontrol/python_clients
./example.py

# Get opc_client for rgp_test_pattern.py
wget https://raw.githubusercontent.com/mens-amplio/mens-amplio/master/modeling/opc_client.py

# js version
npm install -g open-pixel-control

# Adafruit library,, not used at this time.q
# https://learn.adafruit.com/adafruit-neopixel-uberguide
# https://learn.adafruit.com/adafruit-neopixel-uberguide/neomatrix-library
wget https://github.com/adafruit/Adafruit_NeoMatrix/archive/master.zip
unzip master.zip
rm master.zip
wget https://github.com/adafruit/Adafruit-GFX-Library/archive/master.zip
unzip master.zip
rm master.zip

wget https://raw.githubusercontent.com/arduino/Arduino/master/hardware/arduino/avr/cores/arduino/Arduino.h
wget https://raw.githubusercontent.com/arduino/Arduino/master/hardware/arduino/sam/cores/arduino/Arduino.h