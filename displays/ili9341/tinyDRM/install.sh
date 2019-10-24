# Here's where the original file came from
# wget https://github.com/beagleboard/bb.org-overlays/raw/master/src/arm/BB-LCD-ADAFRUIT-18-SPI1-00A0.dts

# mv BB-LCD-ADAFRUIT-18-SPI1-00A0.dts BB-LCD-ADAFRUIT-28-SPI1-00A0.dts

# Edit /boot/uEnv.txt add:
###Additional custom capes
uboot_overlay_addr4=/lib/firmware/BB-LCD-ADAFRUIT-24-SPI1-00A0.dtbo
