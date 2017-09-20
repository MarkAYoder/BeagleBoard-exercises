#!/usr/bin/env python3
# Starts the demos in sequence
# Pin table at https://github.com/beagleboard/beaglebone-blue/blob/master/BeagleBone_Blue_Pin_Table.csv

# Import PyBBIO library:
import Adafruit_BBIO.GPIO as GPIO
import time
import subprocess
import os
import signal

button="PAUSE"  # PAUSE or MODE
LED   ="WIFI"

# Set the GPIO pins:
GPIO.setup(LED,    GPIO.OUT)
GPIO.setup(button, GPIO.IN)

print("Running...")
GPIO.output(LED, 1)

GPIO.wait_for_edge(button, GPIO.RISING)
print("i2cmatrix.py")
proc1 = subprocess.Popen(["./i2cmatrix.py"])
print(proc1.pid)

GPIO.wait_for_edge(button, GPIO.RISING)
print("sequence.py")
proc2 = subprocess.Popen(["./sequence.py"])
print(proc2.pid)

GPIO.wait_for_edge(button, GPIO.RISING)
print("fbi")
subprocess.run(["./on.sh"])
time.sleep(0.5)
subprocess.run(["fbi", "-noverbose", "-T", "1", "-a", "boris.png"])

GPIO.wait_for_edge(button, GPIO.RISING)
print("Killing all")
os.kill(proc1.pid, signal.SIGINT)
os.kill(proc2.pid, signal.SIGINT)