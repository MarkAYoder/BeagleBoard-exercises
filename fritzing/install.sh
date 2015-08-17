wget http://fritzing.org/download/0.9.2b/linux-64bit/fritzing-0.9.2b.linux.AMD64.tar.bz2
tar xvjf fritzing-0.9.2b.linux.AMD64.tar.bz2

# Get Adafruit library 
# From: https://learn.adafruit.com/using-the-adafruit-library-with-fritzing/import-the-library-into-fritzing
wget https://github.com/adafruit/Fritzing-Library/archive/master.zip
unzip master

# Open fritzing
cd fritzing-0.9.2b.linux.AMD64
./Fritzing

# Follow Adafruit instructions
# Pin Fritzing to task bar
