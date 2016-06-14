#!/bin/bash
# Copies scripts from cookbook (https://github.com/jadonk/beaglebone-cookbook.git) 
#   to bone101 (https://github.com/MarkAYoder/bone101.git)

# Assumes cookbook and bone101 are in ~
source=~/beaglebone-cookbook/images
target=~/bone101/examples/cookbook

mkdir -p $target

mkdir -p $target/02-sensors
cp -r $source/sensors/*.js  $target/02-sensors
rm $target/{i2c-scan.js,i2c-test.js}

mkdir -p $target/03-displays
cp -r $source/displays/*.js $target/03-displays

mkdir -p $target/04-motors
cp -r $source/motors/*.js   $target/04-motors

mkdir -p $target/05-beyond
cp -r $source/tips/*.{c,py,sh}     $target/05-beyond

mkdir -p $target/06-iot
cp -r $source/networking/*.js   $target/06-iot

mkdir -p $target/07-kernel
cp -r $source/kernel/*.{c,patch}   $target/07-kernel
cp -r $source/kernel/Makefile   $target/07-kernel

mkdir -p $target/08-realtime
cp -r $source/realtime/*.{c,py,js,h,patch}   $target/08-realtime

mkdir -p $target/09-capes
cp -r $source/capes/*.js    $target/09-capes
