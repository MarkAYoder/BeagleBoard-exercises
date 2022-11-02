# From: https://www.adafruit.com/product/1334?gclid=CjwKCAjwvNaYBhA3EiwACgndgodIwKtxyYJGMfqf98T8Z18HmrOJUGHnm9o0RJIdcyDkijxt0h7S9RoCMEQQAvD_BwE
# This is a RGC color sensor that uses a tcs34725 interface.
# It appears at 0x29 on the i2c bus.

cd sys/bus/i2c/devices/i2c-2
echo tcs3472 0x29 > new_device
debian@node:/sys/bus/i2c/devices/i2c-2$ dmesg -H | tail -2
[Sep 5 15:59] i2c i2c-2: new_device: Instantiated device tcs3472 at 0x29
[  +0.043678] tcs3472 2-0029: TCS34721/34725 found
debian@node:/sys/bus/i2c/devices/i2c-2$ ls
2-0029  2-0055  2-0057         device   name        of_node  subsystem
2-0054  2-0056  delete_device  i2c-dev  new_device  power    uevent
debian@node:/sys/bus/i2c/devices/i2c-2$ cd 2-0029/
debian@node:/sys/bus/i2c/devices/i2c-2/2-0029$ ls
driver  iio:device1  modalias  name  power  subsystem  uevent
debian@node:/sys/bus/i2c/devices/i2c-2/2-0029$ cd iio\:device1/
debian@node:/sys/bus/i2c/devices/i2c-2/2-0029/iio:device1$ ls
buffer                   events                   in_intensity_green_raw         name           trigger
calibscale_available     in_intensity_blue_raw    in_intensity_integration_time  power          uevent
current_timestamp_clock  in_intensity_calibscale  in_intensity_red_raw           scan_elements
dev                      in_intensity_clear_raw   integration_time_available     subsystem
debian@node:/sys/bus/i2c/devices/i2c-2/2-0029/iio:device1$ cat *_raw
1085
4444
1459
1809
