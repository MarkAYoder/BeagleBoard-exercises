#!/usr/bin/env bash
#//////////////////////////////////////
#	buttonEvent.sh
#	Blinks a USR LED when USR button is pressed
#       Waits for a button event
#	Wiring:	
#	Setup:	
#	See:	https://unix.stackexchange.com/questions/428399/how-can-i-run-a-shell-script-on-input-device-event
#//////////////////////////////////////

device='/dev/input/by-path/platform-gpio-keys-event'

LED="3"
LEDPATH='/sys/class/leds/beaglebone:green:usr'

key_off='*value 0*'
 key_on='*value 1*'

evtest --grab "$device" | while read line; do
    case $line in
        ($key_off) echo 0 > ${LEDPATH}${LED}/brightness ;;
        ($key_on)  echo 1 > ${LEDPATH}${LED}/brightness ;;
    esac
done
