#!/usr/bin/env python3
# Usage: issNear.py [address]
# This program will turn on the blue LED if the ISS is within 1000 miles of the given address.
# From: https://codeclubprojects.org/en-GB/python/iss/
# sudo apt install python3-geopy
import gpiod
import json
import urllib.request
import time
import datetime
import threading
import logging
from logging.handlers import RotatingFileHandler

from geopy.geocoders import Nominatim
from geopy.distance  import geodesic

import sys

# Configure logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# Create handlers
file_handler = RotatingFileHandler('iss_tracker.log', maxBytes=1024*1024, backupCount=5)
console_handler = logging.StreamHandler()

# Set levels
file_handler.setLevel(logging.INFO)
console_handler.setLevel(logging.WARNING)

# Create formatters and add it to handlers
log_format = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
file_handler.setFormatter(log_format)
console_handler.setFormatter(log_format)

# Add handlers to the logger
logger.addHandler(file_handler)
logger.addHandler(console_handler)

# calling the Nominatim tool and create Nominatim class
loc = Nominatim(user_agent="Geopy Library")

# Pass location on the command line
if len(sys.argv) > 1:
    address = sys.argv[1] 
else:
    address = "Brazil Indiana USA"
logger.info(f"Looking up address: {address}")
getLoc = loc.geocode(address)
# Check if the address is valid
if getLoc is None:
    logger.error(f"Unable to find location for address '{address}'. Please provide a valid address.")
    sys.exit(1)  # Exit the program with an error code

print(f"Address found: {getLoc.address}")
city = (getLoc.latitude, getLoc.longitude)
logger.info(f"City coordinates: {city}")

url = 'http://api.open-notify.org/iss-now.json'

# Set up GPIO for blue LED
LED_CHIP = 'gpiochip1'
blue   = 18 # 'P9_19'
LED_LINE_OFFSET = [blue]
try:
    chip = gpiod.Chip(LED_CHIP)
    lines = chip.get_lines(LED_LINE_OFFSET)
    lines.request(consumer='blue.py', type=gpiod.LINE_REQ_DIR_OUT)
    logger.info("GPIO setup successful")
except Exception as e:
    logger.error(f"Failed to setup GPIO: {e}")
    sys.exit(1)

# Turn on blue LED
logger.info("Blue LED on")
lines.set_values([1])     # blue LED on

# Function to check if it's nighttime
def is_nighttime():
    current_time = datetime.datetime.now().time()
    # Define nighttime as between 10:00 PM and 5:00 AM
    night_start = datetime.time(22, 0)  # 10:00 PM
    night_end = datetime.time(6, 0)    # 6:00 AM

    # Check if the current time is within the nighttime range
    return current_time >= night_start or current_time <= night_end

# Global variable to control the blinking thread
blinking = False
fast     = False    # Function to blink the LED fast

def blink_led():
    global blinking, fast

    while blinking:
        lines.set_values([1])  # Turn on LED
        time.sleep(0.2 if fast else 1)  # Faster blink if fast=True
        lines.set_values([0])  # Turn off LED
        time.sleep(0.2 if fast else 1)  # Faster blink if fast=True

def get_adaptive_interval(distance):
    """Calculate adaptive interval based on distance"""
    if distance < 750:
        return 30  # Check every 30 seconds when very close
    elif distance < 1500:
        return 60  # Check every minute when moderately close
    elif distance < 2500:
        return 120  # Check every 2 minutes when somewhat close
    else:
        return 300  # Check every 5 minutes when far away

def control_led_based_on_distance():
    global blinking, fast
    
    try:
        # Check if it's nighttime
        if is_nighttime():
            logger.debug("It's nighttime. Turning off the LED.")
            blinking = False  # Stop blinking
            lines.set_values([0])  # Turn off LED
            return 300
        
        # Get the current location of the ISS
        response = urllib.request.urlopen(url)
        result = json.loads(response.read())

        location = result['iss_position']
        iss = (float(location['latitude']), float(location['longitude']))
        logger.debug(f'Current ISS Location: {iss}')

        # Get the distance from the ISS to city
        # geodesic returns distance in miles between two points
        distance = geodesic(iss, city).miles
        # distance = 400  # For testing

        cleaned_address = getLoc.address.replace(", United States", "").strip()
        logger.info(f'Distance from ISS to {cleaned_address}: {int(distance)} miles, {int(distance*1.60934)} km')

        # Check the distance and control the LED
        if distance < 750:
            logger.info("Distance < 750 miles - Fast blinking")
            fast = True  # Set fast blinking
            if not blinking:
                blinking = True
                threading.Thread(target=blink_led, daemon=True).start()
        elif distance < 1500:
            logger.info("Distance < 1500 miles - Normal blinking")
            fast = False
            if not blinking:
                blinking = True
                threading.Thread(target=blink_led, daemon=True).start()
        elif distance < 2500:
            blinking = False  # Stop blinking
            logger.info("Distance < 2500 miles - LED on steady")
            lines.set_values([1])
        else:
            blinking = False  # Stop blinking
            logger.info("Distance > 2500 miles - LED off")
            lines.set_values([0])

        return get_adaptive_interval(distance)

    except Exception as err:
        logger.error(f'Error in control_led_based_on_distance: {err}')
        return 60  # Default to 1 minute on error

# Main loop
logger.info("Starting ISS tracking...")
while True:
    try:
        interval = control_led_based_on_distance()
        logger.debug(f"Next check in {interval} seconds")
        time.sleep(interval)
    except KeyboardInterrupt:
        logger.info("Program terminated by user")
        sys.exit(0)
    except Exception as e:
        logger.error(f"Unexpected error in main loop: {e}")
        time.sleep(60)  # Wait a minute before retrying on error
