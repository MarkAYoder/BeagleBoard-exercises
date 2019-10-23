# Setup for tempKernel.js
cd /sys/class/i2c-adapter/i2c-2
sudo chgrp debian *
sudo chmod g+w delete_device new_device
echo tmp101 0x48 > new_device
cd 2-0048/hwmon/hwmon0
cat temp1_input
