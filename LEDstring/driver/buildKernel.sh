export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
cd ~/BeagleBoard/linux-dev/KERNEL
make modules -j3
