#!/usr/bin/env python3
"""gpiod-based GPIO functionality of a BeagleBone using Python."""
import gpiod
import sys

ALT0 = 4
BOTH = 3
FALLING = 2
HIGH = 1
IN = 0
LOW = 0
OUT = 1
PUD_DOWN = 1
PUD_OFF = 0
PUD_UP = 2
RISING = 1
VERSION = '0.0.0'

ports={}        # Dictionary of channel/line pairs that are open

CONSUMER='GPIOmay'

def setup(channel, direction):
    """Set up the GPIO channel, direction and (optional) pull/up down control.
    
    channel        - channel can be in the form of 'P8_10', or 'EHRPWM2A'
    direction      - INPUT or OUTPUT
    [pull_up_down] - PUD_OFF (default), PUD_UP or PUD_DOWN
    [initial]      - Initial value for an output channel
    [delay]        - Time in milliseconds to wait after exporting gpio pin"""


    found=0
# Searh for channel in either name or consumer
    for chip in gpiod.ChipIter():
        # print('{} - {} lines:'.format(chip.name(), chip.num_lines()))

        for line in gpiod.LineIter(chip):
            offset = line.offset()
            name = line.name()
            consumer = line.consumer()
            linedirection = line.direction()
            active_state = line.active_state()
            
            if name == channel or consumer == channel:

                # print('{}\tline {:>3}: {:>18} {:>12} {:>8} {:>10}'.format(
                #         chip.name(),
                #         offset,
                #         'unnamed' if name is None else name,
                #         'unused' if consumer is None else consumer,
                #         'input' if linedirection == gpiod.Line.DIRECTION_INPUT else 'output',
                #         'active-low' if active_state == gpiod.Line.ACTIVE_LOW else 'active-high'))
                found=1
                break
        if found:
            break

        chip.close()

    if found: 
        print('{}: {}: {}, {}'.format(chip.name(), offset, name, consumer))
    else:
        print(channel + ': Not found')
        sys.exit(1)
    
    # chip = gpiod.Chip(channel[0])
    print(chip)
    
    lines = chip.get_lines([offset])
    # lines = chip.get_lines([channel[1]])
    print(lines)
    if direction == IN:
        lines.request(consumer=CONSUMER, type=gpiod.LINE_REQ_DIR_IN)
    elif direction == OUT:
        lines.request(consumer=CONSUMER, type=gpiod.LINE_REQ_DIR_OUT)
    else:
        print("Unknown direction: " + str(direction))
        sys.exit(1)
        
    ports[channel] = [lines, chip]
    print(ports)

def output(channel, vals):
    """Output to a GPIO channel
    
    gpio  - gpio channel
    value - 0/1 or False/True or LOW/HIGH"""
    print("output()")
    print(channel)
    ret = ports[channel][0].set_values(vals)
    print(ret)
    
def cleanup():
    """Clean up by resetting all GPIO channels that have been used by 
    this program to INPUT with no pullup/pulldown and no event detection."""
    
    print("cleanup()")
    print(ports)
    for channel, val in ports.items():
        print(channel)
        val[0].release()
        val[1].close()
        
        sys.exit(130)
    