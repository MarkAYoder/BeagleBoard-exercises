### kernel driver

This is a simple kernel driver to the pwm channels that lets you set the period, 
duty_cycle and enable.

```
apt-get update
apt-get install linux-headers=`uname -r`    Install the headers for the running version of the kernel
make'     Compile the module
insmod pwm channel=5      Insert the module and select channel 5, which is P8_42
cd /sys/pwm/pwm5          Change to the pwm5 directory
ls
**duty_cycle  enable  period**    These are the file that control the pwm

echo 1000 > duty_cycle        Set the duty_cycle and period.  Units are ns.
echo 2000 > period
