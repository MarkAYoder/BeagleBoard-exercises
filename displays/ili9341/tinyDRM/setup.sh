
FILE=BB-LCD-ADAFRUIT-24-SPI1-00A0
DIR=~/bb.org-overlays

cd $DIR/src/arm
ln -s ~/exercises/displays/ili9341/tinyDRM/$FILE.dts .
cd $DIR
make $FILE.dtbo
# dtc -O dtb -o $FILE.dtbo -b 0 -@ $FILE.dts

cp --backup src/arm/$FILE.dtbo /lib/firmware
