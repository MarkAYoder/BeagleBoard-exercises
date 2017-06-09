#!/usr/bin/env python3
# Makes the robot balance
# Based on: https://github.com/mcdeoliveira/pyctrl/raw/master/examples/rc_mip_balance.py
import math
import time
import warnings
import numpy as np
import sys, tty, termios
import threading

import pyctrl

def brief_warning(message, category, filename, lineno, line=None):
    return "*{}\n".format(message)

warnings.formatwarning = brief_warning

# read key stuff

ARROW_UP    = "\033[A"
ARROW_DOWN  = "\033[B"
ARROW_RIGHT = "\033[C"
ARROW_LEFT  = "\033[D"
DEL         = "."
END         = "/"
SPACE       = " "

def read_key():

    key = sys.stdin.read(1)
    if ord(key) == 27:
        key = key + sys.stdin.read(2)
    elif ord(key) == 3:
        raise KeyboardInterrupt    

    return key

def get_arrows(mip, fd):

    phi_dot_reference = 0
    steer_reference = 180/360
    
    # tty.setcbreak(fd)
    while mip.get_state() != pyctrl.EXITING:
        
        print('\rvelocity = {:+4.0f} '
              '  steering = {:+4.2f} deg'
              .format(100*phi_dot_reference,
                      360*(steer_reference-180/360)),
              end='')
        
        key = read_key()

        if key == ARROW_LEFT:
            steer_reference = max(steer_reference - 20/360, 0)
            mip.set_signal('steer_reference', steer_reference)
        elif key == ARROW_RIGHT:
            steer_reference = min(steer_reference + 20/360, 1)
            mip.set_signal('steer_reference', steer_reference)
        elif key == ARROW_UP:
            phi_dot_reference = phi_dot_reference + 0.1
            mip.set_signal('phi_dot_reference', - phi_dot_reference)
        elif key == ARROW_DOWN:
            phi_dot_reference = phi_dot_reference - 0.1
            mip.set_signal('phi_dot_reference', - phi_dot_reference)
        elif key == SPACE:
            phi_dot_reference = 0
            mip.set_signal('phi_dot_reference', - phi_dot_reference)
            steer_reference = 180/360
            mip.set_signal('steer_reference', steer_reference)
        elif key == DEL:
            steer_reference = 180/360
            mip.set_signal('steer_reference', steer_reference)
        elif key == END:            
            phi_dot_reference = 0
            mip.set_signal('phi_dot_reference', - phi_dot_reference)

def main():

    # import blocks and controller
    from pyctrl.rc.mip import Controller
    from pyctrl.block.system import System, Subtract, Differentiator, Sum, Gain
    from pyctrl.block.nl import ControlledCombination
    from pyctrl.block import Logger, ShortCircuit
    from pyctrl.block.logic import CompareAbs
    from pyctrl.system.ss import DTSS

    # create mip
    mip = Controller()

    # phi is the average of the encoders
    mip.add_signal('phi')
    mip.add_filter('phi',
                   Sum(gain=0.5),
                   ['encoder1','encoder2'],
                   ['phi'])

    # phi dot
    mip.add_signal('phi_dot')
    mip.add_filter('phi_dot',
                   Differentiator(),
                   ['clock','phi'],
                   ['phi_dot'])

    # phi dot reference
    mip.add_signal('phi_dot_reference')

    # state-space matrices
    A = np.array([[0.913134, 0.0363383],[-0.0692862, 0.994003]])
    B = np.array([[0.00284353, -0.000539063], [0.00162443, -0.00128745]])
    C = np.array([[-383.009, 303.07]])
    D = np.array([[-1.22015, 0]])

    B = 2*np.pi*(100/7.4)*np.hstack((-B, B[:,1:]))
    D = 2*np.pi*(100/7.4)*np.hstack((-D, D[:,1:]))

    ssctrl = DTSS(A,B,C,D)

    # state-space controller
    mip.add_signals('pwm')
    mip.add_filter('controller',
                   System(model = ssctrl),
                   ['theta_dot','phi_dot','phi_dot_reference'],
                   ['pwm'])
    
    # steering biasing
    mip.add_signal('steer_reference')
    mip.add_filter('steer',
                   ControlledCombination(),
                   ['steer_reference', 'pwm','pwm'],
                   ['pwm1','pwm2'])

    # set references
    mip.set_signal('phi_dot_reference',0)
    mip.set_signal('steer_reference',0.5)

    # add kill switch
    mip.add_filter('kill',
                   CompareAbs(threshold = 0.2),
                   ['theta'],
                   ['is_running'])
    
    # print controller
    print(mip.info('all'))

    fd = sys.stdin.fileno()
    # old_settings = termios.tcgetattr(fd)
    try:

        print("""
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*                       M I P   B A L A N C E                       *
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
""")

        input('Hold your MIP upright and hit <ENTER> to start balancing')

        print("""
Use your keyboard to control the mip:

* UP and DOWN arrows move forward and back
* LEFT and RIGHT arrows steer
* / stops forward motion
* . stops steering
* SPACE resets forward motion and steering

""")
        
        # reset everything
        mip.set_source('clock',reset=True)
        mip.set_source('encoder1',reset=True)
        mip.set_source('encoder2',reset=True)
        mip.set_filter('controller',reset=True)
        mip.set_source('inclinometer',reset=True)

        # start the controller
        mip.start()

        print("Press Ctrl-C to exit")

        # fire thread to update velocities
        thread = threading.Thread(target = get_arrows,
                                  args = (mip, fd))
        thread.daemon = True
        thread.start()
        
        print("Started thread")
        
        # and wait until controller dies
        mip.join()
        
    except KeyboardInterrupt:

        print("> Balancing aborted")
        mip.set_state(pyctrl.EXITING)

    # finally:
        # termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        
if __name__ == "__main__":
    main()

