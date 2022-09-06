# Wire
# Red   P9_14, 1a
# Green P9_21, 0b
# Blue  P9_22, 0a

config-pin P9_14 pwm
config-pin P9_21 pwm
config-pin P9_22 pwm

cd /dev/bone/pwm/1/a
period=32768
duty_cycle=16000
echo 0 > duty_cycle
echo $period > period
echo $duty_cycle > duty_cycle
echo 1 > enable

cd /dev/bone/pwm/0/a
echo 0 > duty_cycle
echo $period > period
echo $duty_cycle > duty_cycle
echo 1 > enable

cd /dev/bone/pwm/0/b
# period is tied to 'a' side
echo $duty_cycle > duty_cycle
echo 1 > enable

# Configure color sensor
# https://www.adafruit.com/product/1334?gclid=CjwKCAjwvNaYBhA3EiwACgndgodIwKtxyYJGMfqf98T8Z18HmrOJUGHnm9o0RJIdcyDkijxt0h7S9RoCMEQQAvD_BwE
cd /sys/bus/i2c/devices/i2c-2
echo tcs3472 0x29 > new_device
dmesg -H | tail -2

