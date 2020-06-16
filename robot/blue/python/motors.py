#!/usr/bin/env python3
# Run the motors
# Based on: https://github.com/mcdeoliveira/rcpy/raw/master/examples/rcpy_test_motors.py
# import python libraries
import time

import rcpy 
import rcpy.motor as motor

# defaults
duty = 0.3

rcpy.set_state(rcpy.RUNNING)

print("Press Ctrl-C to exit")
    
try:
    d = 0
    direction = 1
    delta = duty/10
    

    while rcpy.get_state() != rcpy.EXITING: # keep running
        # increment duty
        d = d + direction * delta
        motor.set(2, d)
        motor.set(3, d)

        if d > duty or d < -duty:   # end of range?
            direction = direction * -1
                
        time.sleep(.1)  # sleep some

except KeyboardInterrupt:
    # handle what to do when Ctrl-C was pressed
    pass
    
finally:

    # say bye
    print("\nBye BeagleBone!")
        
# exiting program will automatically clean up cape
