apt-get install bluez
# This appears to be an old version of bluez
# Here's how to get the current one
wget http://www.kernel.org/pub/linux/bluetooth/bluez-5.19.tar.xz
tar xvf bluez-5.19.tar.xz
apt-get install libusb-dev libdbus-1-dev libglib2.0-dev automake libudev-dev libical-dev libreadline-dev
./configure --disable-systemd
make	(20 minutes)
make install
cp --backup=numbered attrib/gatttool /usr/bin

hcitool lescan
export BLE=90:59:AF:0B:84:57
hcitool lecc $BLE
hciconfig hci0 reset
gatttool -b $BLE --interactive

connect
char-read-hnd
exit

pip install pexpect

