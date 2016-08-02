apt-get update

apt-get install linux-headers-$(uname -r)

# Fix path
cd /lib/modules/$(uname -r)
rmdir build
ln -s /usr/src/linux-headers-$(uname -r)/ build
