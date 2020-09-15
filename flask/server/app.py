#!/usr/bin/env python3
# From: https://towardsdatascience.com/python-webserver-with-flask-and-raspberry-pi-398423cc6f5d

'''
	Raspberry Pi GPIO Status and Control
'''
import Adafruit_BBIO.GPIO as GPIO
from flask import Flask, render_template
app = Flask(__name__)

button = "P9_11"
senPIR = "P9_11"
buttonSts = GPIO.LOW
senPIRSts = GPIO.LOW
   
# Set button and PIR sensor pins as an input
GPIO.setup(button, GPIO.IN)   
GPIO.setup(senPIR, GPIO.IN)
	
@app.route("/")
def index():
	# Read Sensors Status
	buttonSts = GPIO.input(button)
	senPIRSts = GPIO.input(senPIR)
	templateData = {
      'title' : 'GPIO input Status!',
      'button'  : buttonSts,
      'senPIR'  : senPIRSts
      }
	return render_template('index.html', **templateData)
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=8081, debug=True)