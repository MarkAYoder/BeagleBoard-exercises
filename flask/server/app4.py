#!/usr/bin/env python3
# From: https://towardsdatascience.com/python-webserver-with-flask-and-raspberry-pi-398423cc6f5d
'''
	Raspberry Pi GPIO Status and Control
'''
import Adafruit_BBIO.GPIO as GPIO
from flask import Flask, render_template, request
app = Flask(__name__)
# GPIO.setmode(GPIO.BCM)
# GPIO.setwarnings(False)
#define sensors GPIOs
button = "P9_11"
#define actuators GPIOs
ledRed = "P9_15"
#initialize GPIO status variables
buttonSts = 0
ledRedSts = 0
# Define button and PIR sensor pins as an input
GPIO.setup(button, GPIO.IN)   
# Define led pins as output
GPIO.setup(ledRed, GPIO.OUT)   
# turn leds OFF 
GPIO.output(ledRed, GPIO.LOW)

@app.route("/")
def index():
	# Read GPIO Status
	buttonSts = GPIO.input(button)
	ledRedSts = GPIO.input(ledRed)
	templateData = {
      		'button'  : buttonSts,
      		'ledRed'  : ledRedSts,
      	}
	return render_template('index.html', **templateData)
	
@app.route("/<deviceName>/<action>")
def action(deviceName, action):
	if deviceName == 'ledRed':
		actuator = ledRed

	if action == "on":
		GPIO.output(actuator, GPIO.HIGH)
	if action == "off":
		GPIO.output(actuator, GPIO.LOW)
		     
	buttonSts = GPIO.input(button)
	ledRedSts = GPIO.input(ledRed)

	templateData = {
	 	'button'  : buttonSts,
  		'ledRed'  : ledRedSts,
	}
	return render_template('index.html', **templateData)
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=8081, debug=True)