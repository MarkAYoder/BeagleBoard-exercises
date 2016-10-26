# From: http://elinux.org/EBC_Exercise_31_Dallas_1-Wire

# From Robert Nelson
wget https://raw.githubusercontent.com/beagleboard/bb.org-overlays/master/examples/BB-W1-P9.12/example.sh

# Unconfigure P9_12
cp removeP9_12.patch /tmp
cd /opt/source/bb.org-overlays
git apply /tmp/removeP9_12.patch
make install
# reboot

echo BB-W1-P9.12 > $SLOTS
cd /sys/bus/w1/devices/28*
cat w1_slave

# From Cookbook
# dtc -O dtb -o BB-W1-00A0.dtbo -b 0 -@ BB-W1-00A0.dts
# cp BB-W1-00A0.dtbo /lib/firmware

# echo BB-W1 > $SLOTS

echo "cape_enable=bone_capemgr.enable_partno=BB-W1-P9.12" >> /boot/uEnv.txt
# Then reboot
