#!/bin/bash
# gpio chip=1  line 18=P9_14  line19=P9_16

while true; do 
    gpioset 1 18=0 19=0
    gpioset 1 18=1 19=1
done