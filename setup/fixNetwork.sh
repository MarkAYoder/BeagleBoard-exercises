# This is how I go the network working on my Ubuntu laptop
# Edit /etc/network/interfaces and add:

auto eth0
iface eth0 inet dhcp

# Then run

sudo ifup eth0
