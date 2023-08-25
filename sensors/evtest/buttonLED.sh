#!/usr/bin/env bash
#//////////////////////////////////////
#	buttonLED.sh
#	Blinks a USR LED when USR button is pressed
#       Polls the button
#	Wiring:	
#	Setup:	
#	See:	
#//////////////////////////////////////

LED="3"
 
BUTTONPATH='/dev/input/by-path/platform-gpio-keys-event'
LEDPATH='/sys/class/leds/beaglebone:green:usr'
 
while true ; do
    # evtest returns 0 if not pressed and a non-0 value if pressed.
    evtest --query $BUTTONPATH EV_KEY BTN_0
    echo $? > ${LEDPATH}${LED}/brightness
    sleep 0.1
done
