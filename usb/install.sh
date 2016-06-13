# From : http://hackaday.com/2009/09/18/how-to-write-udev-rules/
# apt-get install libudev-dev
# wget http://www.signal11.us/oss/udev/udev_example.c

# Enable automount when usb drive is inserted
apt-get install usbmount

here=$PWD/81-thumbdrive.rules
cd /etc/udev/rules.d
ln -s $here .
/etc/init.d/udev restart
 