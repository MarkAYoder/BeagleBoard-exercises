# This is for using the si 7021 on the iio interface
# I'm using a si7021, but here we say si7020

BUS=i2c-1
ADDR=0x40
DEV=si7020

cd /sys/class/i2c-adapter/$BUS/
echo $DEV $ADDR > new_device
dmesg -H | tail -2

cd 1-0040/iio\:device1
# Temp appear to be degrees F times 100
temp=`cat in_temp_raw`
echo $(( temp/100 ))

# Print humidity
humid=`cat in_humidityrelative_raw`
echo $(( humid/100 ))
