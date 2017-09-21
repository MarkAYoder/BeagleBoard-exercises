#!/usr/bin/env python3
# Reads the two encoders
# Based on: https://github.com/mcdeoliveira/rcpy/raw/master/examples/rcpy_test_encoders.py

# import python libraries
import time

# import rcpy library
# This automatically initizalizes the robotics cape
import rcpy 
import rcpy.encoder as encoder

rcpy.set_state(rcpy.RUNNING)
print("Press Ctrl-C to exit")

# header
print('     E2 |     E3')
try:
    # keep running
    while True:
        # running
        if rcpy.get_state() == rcpy.RUNNING:
            e2 = encoder.get(2) # read the encoders
            e3 = encoder.get(3)
            print('\r {:+6d} | {:+6d}'.format(e2,e3), end='')
        time.sleep(.5)  # sleep some

except KeyboardInterrupt:
    # Catch Ctrl-C
    pass

finally:
    print("\nBye BeagleBone!")
