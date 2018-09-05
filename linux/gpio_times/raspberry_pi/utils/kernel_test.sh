#!/bin/bash
# script to run the kernel loadable module test
# Note that this script needs to be run AFTER the kernel module
# has been installed (insmod/modprobe)

kernel_execute="/sys/gpio_control/pulse_run"

if [ -f ${kernel_execute} ]
then
	echo "Running the kernel test"
	sudo sh -c "echo g > ${kernel_execute}"
    echo "Kernel test exited"
else
	echo "file ${kernel_execute} doesn't exist - have you installed the kernel module yet?"
fi

cat /sys/gpio_control/gpio_pin
cat /sys/gpio_control/pulse_width
cat /sys/gpio_control/user_delay_type
cat /sys/gpio_control/pulse_run
