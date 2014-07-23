# From: http://nodered.org/docs/getting-started/installation.html
cd
git clone https://github.com/node-red/node-red.git
cd node-red/
npm install --production	# 4 minutes
cd nodes
git clone https://github.com/node-red/node-red-nodes.git # 2 seconds

# To run
# cd ~/node-red
# node red.js

# More modules, 
# From https://learn.adafruit.com/raspberry-pi-hosting-node-red/installing-further-plugins
npm install -g badwords ntwitter oauth sentiment wordpos xml2js firmata fs.notify serialport feedparser pushbullet irc simple-xmpp redis mongodb

# To use sensorTag
# From: https://github.com/sandeepmistry/node-sensortag
apt-get install libbluetooth-dev
npm install -g sensortag
