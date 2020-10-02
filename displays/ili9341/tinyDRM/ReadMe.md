# tinyDRM

(https://dri.freedesktop.org/docs/drm/gpu/tinydrm.html)

Here's where the original file came from
https://github.com/beagleboard/bb.org-overlays/raw/master/src/arm/BB-LCD-ADAFRUIT-18-SPI1-00A0.dts

Use this method for using a framebuffer on the 2.4" LCD display.
```
 bone$ make
 bone$ sudo cp src/arm/BB-LCD-ADAFRUIT-24-SPI1-00A0.dt /lib/firmware/
```

Edit``` /boot/uEnv.txt``` and find the line starting with

```#uboot_overlay_addr4=/lib/firmware```

Uncomment it and change it to:

```uboot_overlay_addr4=/lib/firmware/BB-LCD-ADAFRUIT-24-SPI1-00A0.dtbo```

Then reboot and check for /dev/fb0

## Using
(From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83)

```export FRAMEBUFFER=/dev/fb0```

### Display an image
```sudo fbi -noverbose -T 1 -a tux.png```
### Cycle between several images
```
sudo fbi -t 5 -blend 1000 -noverbose -T 1 -a Matthias.jpg Malachi.jpg Alan.jpg Louis.jpg
```

### Play a movie
```
export SDL_VIDEODRIVER=fbcon 
export SDL_FBDEV=/dev/fb0

mplayer -vf-add rotate=4 -framedrop hst_1.mpg
```
### Look at the framebuffer settings
fbset