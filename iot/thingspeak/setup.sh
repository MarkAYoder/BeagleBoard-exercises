# Setup for tempKernel.js
# This is for bus 1
ADDR=0x49
ADDR2=0049
BUS=1
if [ $BUS = 1 ]; then
    config-pin P9_24 gpio_pu    # turn pull up on
    config-pin P9_26 gpio_pu
    config-pin P9_24 i2c        # Clock
    config-pin P9_26 i2c        # Data
fi

# This is for bus 2
if [ $BUS = 2 ]; then
    config-pin P9_19 i2c        # Clock
    config-pin P9_20 i2c        # Data
fi

# Tell the kernel
cd /sys/class/i2c-adapter/i2c-$BUS
sudo chgrp debian *
sudo chmod g+w delete_device new_device
echo tmp101 $ADDR > new_device
sleep 0.1
cd $BUS-$ADDR2/hwmon/hwmon0
cat temp1_input
