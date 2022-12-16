#!/usr/bin/env python3
# From: https://towardsdatascience.com/python-webserver-with-flask-and-raspberry-pi-398423cc6f5d

'''
	Raspberry Pi GPIO Status and Control
'''
import Adafruit_BBIO.GPIO as GPIO
from flask import Flask, render_template
app = Flask(__name__)

button = "P9_11"
buttonSts = GPIO.LOW

# Set button as an input
GPIO.setup(button, GPIO.IN)   

@app.route("/")
def index():
	# Read Button Status
	buttonSts = GPIO.input(button)
	templateData = {
      'title' : 'GPIO input Status!',
      'button'  : buttonSts,
      }
	return render_template('index2.html', **templateData)
if __name__ == "__main__":
   app.run(host='0.0.0.0', port=8081, debug=True)