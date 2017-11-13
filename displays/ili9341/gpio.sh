# Sets up the UT1 TX and RX pins to be gpio

export GPIO=/sys/class/gpio
export OCP=/sys/devices/platform/ocp

# Define the pins you want to use
export UT1_3=14
export UT1_4=15

# export them
echo $UT1_3 > $GPIO/export
echo $UT1_4 > $GPIO/export

# Set the pinmux to gpio
echo gpio > $OCP/ocp\:P9_24_pinmux/state
echo gpio > $OCP/ocp\:P9_26_pinmux/state

# Make it an input pin and read the value
echo in > $GPIO/gpio$UT1_3/direction
cat $GPIO/gpio$UT1_3/value

echo in > $GPIO/gpio$UT1_4/direction
cat $GPIO/gpio$UT1_4/value
