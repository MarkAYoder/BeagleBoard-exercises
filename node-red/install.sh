# From: http://nodered.org/docs/getting-started/installation.html
git clone https://github.com/node-red/node-red.git
cd node-red/
npm install --production
cd nodes
time git clone https://github.com/node-red/node-red-nodes.git

# To run
cd node-red
node red.js

# More modules, 
# From https://learn.adafruit.com/raspberry-pi-hosting-node-red/installing-further-plugins
npm install badwords ntwitter oauth sentiment wordpos xml2js firmata fs.notify serialport feedparser pushbullet irc simple-xmpp redis mongodb

