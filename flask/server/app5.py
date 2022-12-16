#!/usr/bin/env python3
# From: https://towardsdatascience.com/python-webserver-with-flask-and-raspberry-pi-398423cc6f5d
import gpiod
import sys
from flask import Flask, render_template, request
app = Flask(__name__)
#define sensors GPIOs
getoffsets=[14] # P8_16
#define actuators GPIOs
setoffests=[18] # P9_14
#initialize GPIO status variables
CHIP='1'
# Define button and PIR sensor pins as an input
chip = gpiod.Chip(CHIP)
getlines = chip.get_lines(getoffsets)
getlines.request(consumer="app4.py", type=gpiod.LINE_REQ_DIR_IN)
# Define led pins as output
setlines = chip.get_lines(setoffests)
setlines.request(consumer="app4.py", type=gpiod.LINE_REQ_DIR_OUT)
# turn leds OFF 
setlines.set_values([0])

@app.route("/")
def index():
	# Read GPIO Status
	vals = getlines.get_values()
	templateData = {
	 	'button'  : getlines.get_values()[0],
  		'ledRed'  : setlines.get_values()[0]
    }
	return render_template('index5.html', **templateData)
	
@app.route("/<deviceName>/<action>")
def action(deviceName, action):
	if action == "on":
		setlines.set_values([1])
	if action == "off":
		setlines.set_values([0])
	if action == "toggle":
		if setlines.get_values() == [0]:
			setlines.set_values([1])
		else:
			setlines.set_values([0])

	templateData = {
	 	'button'  : getlines.get_values()[0],
  		'ledRed'  : setlines.get_values()[0]
	}
	return render_template('index5.html', **templateData)
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=8081, debug=True)