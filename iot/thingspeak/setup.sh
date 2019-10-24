# Setup for tempKernel.js
ADDR=49     # TMP101 address
BUS=1       # i2c bus
echo Setting up ADDR=0x$ADDR and BUS=$BUS

if [ $BUS = 1 ]; then
    config-pin P9_24 gpio_pu    # turn pull ups on
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
echo tmp101 0x$ADDR > new_device

# Give it time to appear
sleep 0.1

cd $BUS-00$ADDR/hwmon/hwmon0
cat temp1_input
