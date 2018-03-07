# From: https://www.hackster.io/hologram/cellular-modem-at-command-workshop-299e13?utm_source=hackster&utm_medium=email&utm_campaign=new_projects
# https://learn.adafruit.com/fona-tethering-to-raspberry-pi-or-beaglebone-black/overview

git clone https://github.com/benstr/AT-Workshop.git

sudo apt-get install ppp elinks

wget https://raw.githubusercontent.com/adafruit/FONA_PPP/master/fona

# https://hologram.io/docs/guide/connect/connect-device/
# https://hologram.io/docs/guide/nova/developer-tools/

curl -L hologram.io/python-install | bash
curl -L hologram.io/python-update | bash

PPPATH=/opt/scripts/tools/software/hologram-tools/ppp
sudo bash -c "sed 's/ACM0/O4/' $PPPATH/peers/nova > /etc/ppp/peers/sim800"
sudo cp $PPPATH/chatscripts/nova /etc/chatscripts/sim800
