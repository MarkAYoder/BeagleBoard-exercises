cat $SLOTS
echo -10 > $SLOTS 
echo  BB-SPIDEV0 > $SLOTS
cat $SLOTS
# git clone https://github.com/hackerspaceshop/RaspberryPI_WS2801_Bridge
# cd RaspberryPI_WS2801_Bridge/software
# edit LedStrip_WS2801.py and change self.spi.open(0, 1) to self.spi.open(1, 1)
# Wire BB : GND goes to pin 1 of P9, CO to pin 22 of P9, DO to pin 18 of P9.
