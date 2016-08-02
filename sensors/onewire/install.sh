# From Robert Nelson
wget https://raw.githubusercontent.com/beagleboard/bb.org-overlays/master/examples/BB-W1-P9.12/example.sh

# From Cookbook
# dtc -O dtb -o BB-W1-00A0.dtbo -b 0 -@ BB-W1-00A0.dts
# cp BB-W1-00A0.dtbo /lib/firmware

# echo BB-W1 > $SLOTS

echo "cape_enable=bone_capemgr.enable_partno=BB-W1-P9.12" >> /boot/uEnv.txt
# Then reboot
