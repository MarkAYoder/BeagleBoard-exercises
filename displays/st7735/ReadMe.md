## Adafruit 1.8" LCD
The Adafruit LCD (https://www.adafruit.com/products/358) is 128x160 color SPI-based LCD.
There are nice instructions: http://beagleboard.org/project/bbb-lcd-fbtft-prebuilt/

Wiki: https://github.com/notro/fbtft/wiki

## Device Tree
Device tree should already be  installed.  There are a versions for SPI0 and SPI1

```BB-LCD-ADAFRUIT-18-SPI0-00A0.dts``` and ```BB-LCD-ADAFRUIT-18-SPI1-00A0.dts```

Look in /opt/source/bb.org-overlays/src/arm or
https://github.com/beagleboard/bb.org-overlays/tree/master/src/arm

To compile
``` 
bone$ cd /opt/source/bb.org-overlays/
bone$ make
bone$ sudo make install
 ```
Edit /boot/uEnv.txt around line 20 you'll find:

```#uboot_overlay_addr4=<file4>.dtbo```

* Remove the leading # and change ```<file4>.dtbo``` to ```BB-LCD-ADAFRUIT-18-SPI0-00A0.dtbo```
* Save and reboot
* /dev/fb0 should appear
