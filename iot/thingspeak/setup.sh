# Setup for tempKernel.js
# This is for bus 2
config-pin P9_19 i2c        # Clock
config-pin P9_20 i2c        # Data

# Tell the kernel
cd /sys/class/i2c-adapter/i2c-2
sudo chgrp debian *
sudo chmod g+w delete_device new_device
echo tmp101 0x48 > new_device
cd 2-0048/hwmon/hwmon0
cat temp1_input
