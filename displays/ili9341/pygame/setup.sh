# This is for at TMP101 sensor on i2c bus 1 and address 0x49

# These are for i2c bus 1
config-pin P9_24 i2c
config-pin P9_26 i2c

cd /sys/class/i2c-adapter/i2c-1

# Create the device
echo tmp101 0x49 > new_device

# Check the temp (in mC)
cat /sys/class/hwmon/hwmon0/temp1_input
