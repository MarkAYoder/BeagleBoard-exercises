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
./opc_server &

# Start a pattern
cd openpixelcontrol/python_clients
./example.py

# Get opc_client for rgp_test_pattern.py
wget https://raw.githubusercontent.com/mens-amplio/mens-amplio/master/modeling/opc_client.py

# js version
npm install -g open-pixel-control
