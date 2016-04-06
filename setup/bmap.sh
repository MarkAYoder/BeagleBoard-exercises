# This is a faster way than dd to copy a disk image
# http://elinux.org/BeagleBoardDebian#BeagleBone_White.2FBlack.2FGreen

sudo apt-get install bmap-tools
# The apt-get may get an old version, if so run
# sudo apt-get update
# sudo apt-get install bmap-tools/jessie

sudo bmaptool copy bone-debian-7.8-console-armhf-2015-07-28-2gb.img.xz /dev/mmcblk0
