#!/bin/bash
# Read Accleration and Gyro's on MPU-6050 imu
# Turn off sleep mode
i2cset -y 1 0x68 107 0 b

