# Setup for tempKernel.js
ADDR=49     # TMP101 address
BUS=2       # i2c bus
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
dev=/sys/class/i2c-adapter/i2c-$BUS
echo tmp101 0x$ADDR > "$dev/new_device"

# Give it time to appear
sleep 0.1

cat "$dev/$BUS-00$ADDR/hwmon/hwmon0/temp1_input"

# https://thingspeak.com/channels/538706/api_keys
export THING_KEY=VKBLZME68539A9HX