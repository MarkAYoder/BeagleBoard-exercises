# Script for starting MPL3113
# From: https://github.com/vmayoral/bb_altimeter/blob/master/scripts/mpl2115a2.py
MPL=0x60
i2cset -y 1 $MPL 0x26 0xb8
i2cset -y 1 $MPL 0x13 0x07
i2cset -y 1 $MPL 0x26 0xb9
i2cdump -y 1 $MPL
i2cget -y 1 $MPL 0x04
