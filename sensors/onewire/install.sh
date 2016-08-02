# From Cookbook
dtc -O dtb -o BB-W1-00A0.dtbo -b 0 -@ BB-W1-00A0.dts
cp BB-W1-00A0.dtbo /lib/firmware

echo BB-W1 > $SLOTS
