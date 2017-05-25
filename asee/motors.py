#!/usr/bin/env python3
# Run the motors
# Based on: https://github.com/mcdeoliveira/rcpy/raw/master/examples/rcpy_test_motors.py
# import python libraries
import time

# import rcpy library
# This automatically initizalizes the robotics cape
import rcpy 
import rcpy.motor as motor

# defaults
duty = 0.3

# set state to rcpy.RUNNING
rcpy.set_state(rcpy.RUNNING)

# message
print("Press Ctrl-C to exit")
    
try:
    d = 0
    direction = 1
    delta = duty/10
    
    # keep running
    while rcpy.get_state() != rcpy.EXITING:

        # increment duty
        d = d + direction * delta
        motor.set(2, d)
        motor.set(3, d)

        # end of range?
        if d > duty or d < -duty:
            direction = direction * -1
                
        # sleep some
        time.sleep(.1)

except KeyboardInterrupt:
    # handle what to do when Ctrl-C was pressed
    pass
    
finally:

    # say bye
    print("\nBye BeagleBone!")
        
# exiting program will automatically clean up cape
