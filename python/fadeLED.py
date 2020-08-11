#!/usr/bin/python3
#//////////////////////////////////////
# 	fadeLED.py
#   Fades the LED wired to P9_14 using the PWM.
# 	Wiring:	P9_14 connects to the plus lead of an LED.  The negative lead of the
# 			LED goes to a 220 Ohm resistor.  The other lead of the resistor goes
# 			to 3.3V (P9_3).
#//////////////////////////////////////
import PWMmay as PWM
import time
LED = 'P9_14'
step = 10       # Step size
min =  0        # dimmest value
max =  100      # brightest value
brightness = min # Current brightness;
 
err = PWM.start(LED, brightness)
if err == None:
   exit()

try:
    while True:
        PWM.set_duty_cycle(LED, brightness)
        brightness += step
        if(brightness >= max or brightness <= min):
            step = -1 * step
        time.sleep(0.04)

except KeyboardInterrupt:
    print("TStopping: " + LED)
    PWM.stop(LED)