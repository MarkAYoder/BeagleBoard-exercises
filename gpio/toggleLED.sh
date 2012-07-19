#!/bin/bash
# From http://wh1t3s.com/2009/05/14/reading-beagleboard-gpio/
# Orginally /usr/bin/readgpio, Modified by Mark A. Yoder 20-Jul-2011
#
# Toggle a GPIO input
if [ $# -lt 3 ]; then
    echo "Usage: $0 <gpio pin#> <On Time> <Off Time>"
    exit 0
fi
LED=$1
PERIODon=$2
PERIODoff=$3
LEDPATH=/sys/class/leds/beagleboard::usr$LED

cleanup() { # Set the GPIO port to 0
  echo "Cleaning up"
  echo $BRIGHTNESS > $LEDPATH/brightness
#  echo $TRIGGER > $LEDPATH/trigger
  exit
}

savesettings() {
  BRIGHTNESS=`cat $LEDPATH/brightness`
  echo brightness=$BRIGHTNESS
  TRIGGER=`cat $LEDPATH/trigger`
  echo trigger=$TRIGGER
  echo none > $LEDPATH/trigger
}

trap cleanup SIGINT # call cleanup on Ctrl-C

savesettings

# Run forever

while [ "1" = "1" ]; do

  if [ "1" = "$THIS_VALUE" ]; then
     THIS_VALUE=0
     sleep $PERIODon
   else
     THIS_VALUE=1
     sleep $PERIODoff
  fi
  echo $THIS_VALUE > $LEDPATH/brightness

done

cleanup # call the cleanup routine

