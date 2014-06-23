#!/bin/bash
# dtc -O dtb -o bone_eqep2b-00A0.dtbo -b 0 -@ bone_eqep2b.dts 
cp bone_eqep2b-00A0.dtbo /lib/firmware
echo bone_eqep2b > $SLOTS 

