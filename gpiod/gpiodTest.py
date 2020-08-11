#!/usr/bin/env python3

# From: https://pypi.org/project/gpiod/0.5.4/
import gpiod
import sys
import time

if len(sys.argv) > 2:
    LED_CHIP = sys.argv[1]
    LED_LINE_OFFSET = int(sys.argv[2])
else:
    print('''Usage:
    python3 blink.py <chip> <line offset>''')
    sys.exit()

chip = gpiod.chip(LED_CHIP)
led = chip.get_line(LED_LINE_OFFSET)

config = gpiod.line_request()
config.consumer = "Blink"
config.request_type = gpiod.line_request.DIRECTION_OUTPUT

led.request(config)

while True:
    led.set_value(0)
    # time.sleep(0.1)
    led.set_value(1)
    # time.sleep(0.1)