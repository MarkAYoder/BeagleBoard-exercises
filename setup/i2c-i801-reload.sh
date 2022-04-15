#!/bin/sh
# From: https://www.mail-archive.com/search?l=ubuntu-bugs@lists.ubuntu.com&q=subject:%22%5C%5BBug+1786574%5C%5D+Re%5C%3A+remove+i2c%5C-i801+from+blacklist%22&o=newest&f=1
case $1 in
  pre)
modprobe -r i2c-i801
;;
  post)
modprobe i2c-i801
;;
esac

