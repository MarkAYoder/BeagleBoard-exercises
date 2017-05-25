#!/usr/bin/env python3
# Reads the two encoders
# Based on: https://github.com/mcdeoliveira/rcpy/raw/master/examples/rcpy_test_encoders.py

# import python libraries
import time

# import rcpy library
# This automatically initizalizes the robotics cape
import rcpy 
import rcpy.encoder as encoder

def main():
    # set state to rcpy.RUNNING
    rcpy.set_state(rcpy.RUNNING)

    # message
    print("Press Ctrl-C to exit")

    # header
    print('     E2 |     E3')

    try:

        # keep running
        while True:

            # running
            if rcpy.get_state() == rcpy.RUNNING:
                
                # read all encoders
                e2 = encoder.get(2)
                e3 = encoder.get(3)

                print('\r {:+6d} | {:+6d}'.format(e2,e3), end='')

            # sleep some
            time.sleep(.5)

    except KeyboardInterrupt:
        # Catch Ctrl-C
        pass
    
    finally:

        # say bye
        print("\nBye Beaglebone!")
            
# exiting program will automatically clean up cape

if __name__ == "__main__":
    main()
