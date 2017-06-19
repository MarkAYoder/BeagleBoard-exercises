BALPATH=/opt/source/Robotics_Cape_Installer/examples/my_balance
make -C $BALPATH

sudo chown root:root rc_balance 
sudo chmod +s rc_balance

ln --backup -s $BALPATH/rc_balance .
