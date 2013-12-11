Device Tree Notes.

If you are running the 3.8 kernel you need to enable SPI via the device tree
These steps come from [1]

beagle$ dtc -O dtb -o BB-SPI1-01-00A0.dtbo -b 0 -@ BB-SPI1-01-00A0.dts
beagle$ cp BB-SPI1-01-00A0.dtbo /lib/firmware/
beagle$ echo BB-SPI1-01 > /sys/devices/bone_capemgr.*/slots

Now you should see:
beagle$ ls -al /dev/spidev*  
crw------- 1 root root 153, 0 Jun  5 16:48 /dev/spidev1.1


[1] http://hipstercircuits.com/enable-spi-with-device-tree-on-beaglebone-black-copy-paste/
