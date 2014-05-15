cat $SLOTS
echo -10 > $SLOTS 
cat $SLOTS
echo  BB-SPIDEV0 > $SLOTS
cd py-spidev
python setup.py install
