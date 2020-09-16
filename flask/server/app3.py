#!/usr/bin/env python3
# From: https://towardsdatascience.com/python-webserver-with-flask-and-raspberry-pi-398423cc6f5d
'''
	Raspberry Pi GPIO Status and Control
'''
import Adafruit_BBIO.GPIO as GPIO
from flask import Flask, render_template, request
app = Flask(__name__)
#define LED GPIOs
ledRed = "P9_15"
#initialize GPIO status variable
ledRedSts = 0
# Define led pins as output
GPIO.setup(ledRed, GPIO.OUT)   
# turn leds OFF 
GPIO.output(ledRed, GPIO.HIGH)

@app.route("/")
def index():
	# Read Sensors Status
	ledRedSts = GPIO.input(ledRed)
	templateData = {
              'title' : 'GPIO output Status!',
              'ledRed'  : ledRedSts,
        }
	return render_template('index3.html', **templateData)
	
@app.route("/<deviceName>/<action>")
def action(deviceName, action):
	if deviceName == 'ledRed':
		actuator = ledRed

	if action == "on":
		GPIO.output(actuator, GPIO.HIGH)
	if action == "off":
		GPIO.output(actuator, GPIO.LOW)
		     
	ledRedSts = GPIO.input(ledRed)

	templateData = {
              'ledRed'  : ledRedSts,
	}
	return render_template('index3.html', **templateData)
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=8081, debug=True)