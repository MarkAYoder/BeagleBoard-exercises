#!/bin/bash
# Read Accleration and Gyro's on MPU-6050 imu
# From https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&ved=0CC4QFjAA&url=http%3A%2F%2Fwww.invensense.com%2Fmems%2Fgyro%2Fdocuments%2FRM-MPU-6000A.pdf&ei=wbRWUv3_BIa9yAH8koG4Dg&usg=AFQjCNGMe9VN0PFZyjYnyNbtvbtpJdq5ag&sig2=vuo4xibJah21ZwyJFRtYAg&bvm=bv.53760139,d.aWc
BUS=1
ADDR=0x68
# Turn off sleep mode p41
i2cset -y $BUS $ADDR 107 0 b
# Configure gyro for +- 250 deg/s p14
i2cset -y $BUS 0x68 27 0 b
# Configure accelerometer for +- 2g p15
i2cset -y $BUS $ADDR 28 0 b

# Read Accelerometer X, Y, Z
echo -ne "Accelerometer:\t"
echo `i2cget -y $BUS $ADDR 59` `i2cget -y $BUS $ADDR 60` \
     `i2cget -y $BUS $ADDR 61` `i2cget -y $BUS $ADDR 62` \
     `i2cget -y $BUS $ADDR 63` `i2cget -y $BUS $ADDR 64` 
sleep 1
echo `i2cget -y $BUS $ADDR 59 w` \
     `i2cget -y $BUS $ADDR 61 w` \
     `i2cget -y $BUS $ADDR 63 w`

# Read Gyro X, Y, Z
echo -ne "Gyro:\t\t"
echo `i2cget -y $BUS $ADDR 67` `i2cget -y $BUS $ADDR 68` \
     `i2cget -y $BUS $ADDR 69` `i2cget -y $BUS $ADDR 70` \
     `i2cget -y $BUS $ADDR 7$BUS` `i2cget -y 1 0x68 72` 