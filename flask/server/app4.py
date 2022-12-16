#!/usr/bin/env python3
# From: https://towardsdatascience.com/python-webserver-with-flask-and-raspberry-pi-398423cc6f5d
import gpiod
import sys
# import Adafruit_BBIO.GPIO as GPIO
from flask import Flask, render_template, request
app = Flask(__name__)
# GPIO.setmode(GPIO.BCM)
# GPIO.setwarnings(False)
#define sensors GPIOs
getoffsets=[14] # P8_16
# button = "P9_11"
#define actuators GPIOs
setoffests=[18] # P9_14
# ledRed = "P9_15"
#initialize GPIO status variables
buttonSts = 0
ledRedSts = 0
CHIP='1'
# Define button and PIR sensor pins as an input
chip = gpiod.Chip(CHIP)
getlines = chip.get_lines(getoffsets)
getlines.request(consumer="app4.py", type=gpiod.LINE_REQ_DIR_IN)
# GPIO.setup(button, GPIO.IN)   
# Define led pins as output
setlines = chip.get_lines(setoffests)
setlines.request(consumer="app4.py", type=gpiod.LINE_REQ_DIR_OUT)
# GPIO.setup(ledRed, GPIO.OUT)   
# turn leds OFF 
setlines.set_values([0])
# GPIO.output(ledRed, GPIO.LOW)

@app.route("/")
def index():
	# Read GPIO Status
	vals = getlines.get_values()
	# buttonSts = GPIO.input(button)
	# ledRedSts = GPIO.input(ledRed)
	templateData = {
		'button'  : buttonSts,
		'ledRed'  : '0',
    }
	return render_template('index.html', **templateData)
	
@app.route("/<deviceName>/<action>")
def action(deviceName, action):
	if deviceName == 'ledRed':
		actuator = "0"

	if action == "on":
		setlines.set_values([1])
		# GPIO.output(actuator, GPIO.HIGH)
	if action == "off":
		setlines.set_values([0])
		# GPIO.output(actuator, GPIO.LOW)
		     
	vals = getlines.get_values()
	# setlines.set_values(vals)
	# buttonSts = GPIO.input(button)
	# ledRedSts = GPIO.input(ledRed)

	templateData = {
	 	'button'  : vals,
  		'ledRed'  : vals,
	}
	return render_template('index3.html', **templateData)
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=8081, debug=True)