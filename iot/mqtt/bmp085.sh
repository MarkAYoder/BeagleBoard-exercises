# This reads the current temp from a bmp085 sensor on i2c bus 2 at 0x77 and publishes it.
# This is for the bmp085 temp/humitity sensor on i2c bus 2 at 0x77

# config-pin P9_19 i2c
# config-pin P9_20 i2c

# I2C=/sys/class/i2c-adapter/i2c-2
# cd $I2C
# sudo chgrp i2c new_device
# sudo chmod g+w new_device
# echo bmp085 0x77 > new_device

i=0
BMP085=/sys/class/i2c-adapter/i2c-2/2-0077/iio:device2

while true; do
        TEMP=`cat $BMP085/in_temp_input`;  # TEMP=$(($TEMP*9/5+32*1000))
    PRESSURE=`cat $BMP085/in_pressure_input`
    mosquitto_pub -t 'temp'     -m "`date`, $i: $TEMP"
    mosquitto_pub -t 'pressure' -m "`date`, $i: $PRESSURE"
    i=$[$i+1]
    sleep 15
done
