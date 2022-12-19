#!/usr/bin/env python3
# From: https://towardsdatascience.com/python-webserver-with-flask-and-raspberry-pi-398423cc6f5d
import gpiod
import sys
# import Adafruit_BBIO.GPIO as GPIO
from flask import Flask, render_template, request
app = Flask(__name__)

#define LED GPIOs
CHIP='1'
setoffests=[18] # P9_14, red LED
ledRed = "P9_14"
# Define led pins as output
chip = gpiod.Chip(CHIP)
setlines = chip.get_lines(setoffests)
setlines.request(consumer="app3.py", type=gpiod.LINE_REQ_DIR_OUT)
# turn led OFF 
setlines.set_values([0])

@app.route("/")
def index():
	# Read Sensors Status
	ledRedSts = '0'
	templateData = {
              'title' : 'GPIO output Status!',
              'ledRed'  : setlines.get_values()[0]

        }
	return render_template('index3.html', **templateData)
	
@app.route("/<deviceName>/<action>")
def action(deviceName, action):
	if action == "on":
		setlines.set_values([1])
		ledRedSts = '1'
	if action == "off":
		setlines.set_values([0])
		ledRedSts = '0'
		     
	templateData = {
        'title' : 'GPIO output Status!',
        'ledRed'  : setlines.get_values(),
	}
	return render_template('index3.html', **templateData)
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=8081, debug=True)