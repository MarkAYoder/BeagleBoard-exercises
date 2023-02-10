# Installing MPU6050 gyro

Find the device tree

cd /boot/dtbs/`uname -r`/overlays
ls *MPU*
BB-I2C2-MPU6050.dtbo

Edit /boot/uEnv.txt and add

` ###Additional custom capes`

`uboot_overlay_addr5=BB-I2C2-MPU6050.dtbo`

Reboot and check:
`ls /proc/device-tree/chosen/overlays/`

`BB-ADC-00A0.kernel  BB-BONE-eMMC1-01-00A0.kernel  BB-I2C2-MPU6050.kernel  name`

Read the device

`/sys/class/i2c-adapter/i2c-2/2-0068/iio:device1`
ls
buffer                    in_accel_z_raw              in_temp_raw
current_timestamp_clock   in_anglvel_mount_matrix     in_temp_scale
dev                       in_anglvel_scale            name
in_accel_matrix           in_anglvel_scale_available  of_node
in_accel_mount_matrix     in_anglvel_x_calibbias      power
in_accel_scale            in_anglvel_x_raw            sampling_frequency
in_accel_scale_available  in_anglvel_y_calibbias      sampling_frequency_available
in_accel_x_calibbias      in_anglvel_y_raw            scan_elements
in_accel_x_raw            in_anglvel_z_calibbias      subsystem
in_accel_y_calibbias      in_anglvel_z_raw            trigger
in_accel_y_raw            in_gyro_matrix              uevent
in_accel_z_calibbias      in_temp_offset

cat in_accel_*_raw
-14972
-3368
-12

# Documentation: https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-bus-iio 