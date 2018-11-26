#!/bin/bash
# This start the ili9341 display and the IR Array.

DIS=/home/debian/exercises/displays/ili9341/fb
cd $DIS
./on.sh

SENSOR=/home/debian/exercises/sensors/IRArray
cd $SENSOR
./setup.sh

while [ ! -e /dev/fb0 ]
do
  echo Waiting for /dev/fb0
  sleep 2
done

mlx90640-library/interp &

./takePicture.py
