#
# Using i2c 1
SCL=P9_24       # Clock
SDA=P9_26       # Data

config-pin $SCL i2c
config-pin -q $SCL

config-pin $SDA i2c
config-pin -q $SDA
