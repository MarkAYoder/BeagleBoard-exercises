# Here's what I do to get cape-universal to load
# From https://github.com/cdsteinkuehler/beaglebone-universal-io
echo -7 > $SLOTS 
echo -8 > $SLOTS 
echo -10 > $SLOTS 
config-pin overlay cape-universaln
