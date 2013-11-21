#!/bin/bash
# From page 224 of Embedded Linux Primer
# Be sure to source ~/crossCompileEnv.sh

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
DRIVER_PATH=~/BeagleBoard/linux-dev/KERNEL/drivers/char

cp lpd8806.c $DRIVER_PATH
pushd $DRIVER_PATH
make -C ~/BeagleBoard/linux-dev/KERNEL SUBDIRS=$PWD modules

popd
cp $DRIVER_PATH/lpd8806.ko .

scp lpd8806.ko bone:.
