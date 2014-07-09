# From: http://nodered.org/docs/getting-started/installation.html
git clone https://github.com/node-red/node-red.git
cd node-red/
npm install --production	# 4 minutes
cd nodes
git clone https://github.com/node-red/node-red-nodes.git # 2 seconds

# To run
cd node-red
node red.js

# To use sensorTag
# From: https://github.com/sandeepmistry/node-sensortag
apt-get install libbluetooth-dev
npm install -g sensortag
