#!/bin/bash
# Turns off and on the LED triggers
LEDpath='/sys/class/leds/beaglebone:green:usr'
onTrigger=(heartbeat mmc0 cpu0 mmc1)

if [ x$1 == "xoff" ]; then
    for led in {0..3}
    do
        echo none > ${LEDpath}${led}/trigger
    done
else
    for led in {0..3}
    do
        echo ${onTrigger[$led]} > ${LEDpath}$led/trigger
    done
fi
