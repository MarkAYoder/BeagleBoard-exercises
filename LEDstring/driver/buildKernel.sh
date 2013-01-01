export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
cd ~/BeagleBoard/kernel/kernel
make modules -j9
