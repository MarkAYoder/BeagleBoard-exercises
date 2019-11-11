VERS=0.9.3b
wget http://fritzing.org/download/$VERS/linux-64bit/fritzing-$VERS.linux.AMD64.tar.bz2
tar xvjf fritzing-$VERS.linux.AMD64.tar.bz2

# Get Adafruit library 
# From: https://learn.adafruit.com/using-the-adafruit-library-with-fritzing/import-the-library-into-fritzing
wget https://github.com/adafruit/Fritzing-Library/archive/master.zip
unzip master

# Open fritzing
cd fritzing-$VERS.linux.AMD64
./Fritzing

# Follow Adafruit instructions: https://learn.adafruit.com/using-the-adafruit-library-with-fritzing
# Pin Fritzing to task bar
