#!/usr/bin/env python3
# import python libraries
import time
import getopt, sys

# import rcpy library
# This automatically initizalizes the robotics cape
import rcpy 
import rcpy.mpu9250 as mpu9250

def main():

    # Parse command line
    # defaults
    enable_magnetometer = True

    # set state to rcpy.RUNNING
    rcpy.set_state(rcpy.RUNNING)

    mpu9250.initialize(enable_magnetometer = enable_magnetometer)

    # message
    print("Press Ctrl-C to exit")

    # header
    print("   Accel XYZ (m/s^2) |"
          "    Gyro XYZ (deg/s) |", end='')
    print("  Mag Field XYZ (uT) |", end='')
    print(' Temp (C)')

    try:

        # keep running
        while True:

            # running
            if rcpy.get_state() == rcpy.RUNNING:
                
                temp = mpu9250.read_imu_temp()
                data = mpu9250.read()
            
                print(('\r{0[0]:6.2f} {0[1]:6.2f} {0[2]:6.2f} |'
                       '{1[0]:6.1f} {1[1]:6.1f} {1[2]:6.1f} |'
                       '{2[0]:6.1f} {2[1]:6.1f} {2[2]:6.1f} |'
                       '   {3:6.1f}').format(data['accel'],
                                             data['gyro'],
                                             data['mag'],
                                             temp),
                      end='')
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
