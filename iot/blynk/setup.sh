export BLYNK_AUTH='087e4c21298e413ab9d5f87a5279e5c9'

# If useing BMP085 Temp/Pressure sensor

I2C=/sys/class/i2c-adapter/i2c-2
echo bmp085 0x77 > $I2C/new_device
