config-pin P9_11 uart
config-pin P9_13 uart

PPPATH=/opt/scripts/tools/software/hologram-tools/ppp

sudo bash -c "sed 's/ACM0/O4/' $PPPATH/peers/nova > /etc/ppp/peers/nova"
sudo cp $PPPATH/chatscripts/nova /etc/chatscripts
