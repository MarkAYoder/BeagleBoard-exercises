
FILE=BB-LCD-ADAFRUIT-24-SPI1-00A0
INCLUDE=/opt/source/dtb-4.19-ti/include

# cd $DIR/src/arm
# ln -s ~/exercises/displays/ili9341/tinyDRM/$FILE.dts .
# cd $DIR
# make $FILE.dtbo

dtc --include $INCLUDE -I dts -O dtb -o $FILE.dtbo -b 0 -@ $FILE.dts

cp --backup src/arm/$FILE.dtbo /lib/firmware


DTC=dtc
DTCFLAGS="b 0"
dtc_cpp_flags="-x assembler-with-cpp -nostdinc         \
                 -I $INCLUDE         \
                 -undef -D__DTS__"

DTCINCLUDES="-i $INCLUDE"

cpp $dtc_cpp_flags < $FILE.dts | $DTC $DTCINCLUDES -I dts -O dtb $DTCFLAGS -o $FILE.dtbo -
