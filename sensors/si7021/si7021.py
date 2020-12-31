#!/usr/bin/env python3
# Prints the temperature and humidity for s si7021 using the iio interface
BUS="i2c-1"
ADDR="0x40"
PATH="/sys/class/i2c-adapter/" + BUS + "/1-0040/iio:device1/"

print(PATH)
fd = open(PATH + "in_temp_raw")
print(str(float(fd.read().replace('\n', ''))/100) + "°")
fd.close()

fd = open(PATH + "in_humidityrelative_raw")
print(str(float(fd.read().replace('\n', ''))/100) + "%")
fd.close()
