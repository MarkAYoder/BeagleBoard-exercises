# From: https://github.com/sandeepmistry/node-sensortag
apt-get install libbluetooth-dev libudev-dev bluez
npm install -g sensortag async noble-device
hcitool lescan

ln -s $NODE_PATH/sensortag .
