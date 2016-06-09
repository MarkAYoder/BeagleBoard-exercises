#!/usr/bin/env python

import Adafruit_BBIO.GPIO as GPIO 	#Import BBB GPIO pins
import Adafruit_BBIO.ADC as ADC		#Import BBB ADC pins 
import time
from time import localtime, strftime
import csv 

collecting = 0	#Set to 0 at midnight

scale_1 = 1	#1st Battery Level (0-6V)	
scale_2 = 1	#2nd Battery Level (6-12V)	
scale_3 = 1	#3rd Battery Level (12-18V)

GPIO.setup("P9_12", GPIO.OUT)	#Initialize GPIO pin for output
GPIO.setup("P9_14", GPIO.OUT)	
GPIO.setup("P9_16", GPIO.OUT)
GPIO.setup("P9_18", GPIO.OUT)	#A1	
GPIO.setup("P9_22", GPIO.OUT)	#A0

while 1:

	if collecting == 0:
		csvfile = open("/usr/src/La.20" + strftime("%y.%m.%d", localtime()) + ".csv","w")	#Create file for data to be stored
		fieldnames = ["timestamp","time","Battery 1 (V)","Battery 2 (V)","Battery 3 (V)","Battery 4 (V)",
"Battery 5 (V)","Battery 6 (V)","Battery 7 (V)","Battery 8 (V)","Battery 9 (V)","Battery 10 (V)","Battery 11 (V)","Battery 12 (V)",
"Current 1","FIO5","FIO6","FIO7","Temp"]	#Create header in file
		writer = csv.DictWriter(csvfile, fieldnames = fieldnames, lineterminator = "\n")
		#writer.writeheader()	#Writes header onto .csv file
		collecting = 1

	ADC.setup()
	wait_time = 3 	#Seconds to wait
	pause_time = 0.1  

	while collecting:
############################################################################################################################################################
		GPIO.output("P9_12", GPIO.LOW)	#A11	#Select battery string 1
		GPIO.output("P9_14", GPIO.LOW)	#A00	
		
		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 1
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN

		time.sleep(pause_time)

		value_current_1 = ADC.read("AIN0")	#Read pin 39
		voltage_current_1 = value_current_1 * 1.8	
		current_1 = voltage_current_1 * 50	#Convert value to measured current

		value_1 = ADC.read("AIN1")	#Read pin 40
		value_5 = ADC.read("AIN2")	#Read pin 37
		value_9 = ADC.read("AIN3")	#Read pin 38
		voltage_1 = value_1 * 1.8	#Convert value to measured voltage
		voltage_5 = value_5 * 1.8
		voltage_9 = value_9 * 1.8
		battery_1 = voltage_1 * scale_1
		battery_5 = voltage_5 * scale_2
		battery_9 = voltage_9 * scale_3	

		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 2
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_2 = ADC.read("AIN1")
		value_6 = ADC.read("AIN2")
		value_10 = ADC.read("AIN3")		
		voltage_2 = value_2 * 1.8
		voltage_6 = value_6 * 1.8
		voltage_10 = value_10 * 1.8		
		battery_2 = voltage_2 * scale_1
		battery_6 = voltage_6 * scale_2
		battery_10 = voltage_10 * scale_3

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 3
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_3 = ADC.read("AIN1")
		value_7 = ADC.read("AIN2")
		value_11 = ADC.read("AIN3")		
		voltage_3 = value_3 * 1.8
		voltage_7 = value_7 * 1.8
		voltage_11 = value_11 * 1.8		
		battery_3 = voltage_3 * scale_1
		battery_7 = voltage_7 * scale_2
		battery_11 = voltage_11 * scale_3

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 4
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_4 = ADC.read("AIN1")
		value_8 = ADC.read("AIN2")
		value_12 = ADC.read("AIN3")		
		voltage_4 = value_4 * 1.8
		voltage_8 = value_8 * 1.8
		voltage_12 = value_12 * 1.8		
		battery_4 = voltage_4 * scale_1
		battery_8 = voltage_8 * scale_2
		battery_12 = voltage_12 * scale_3

############################################################################################################################################################
		GPIO.output("P9_12", GPIO.LOW)	#A11	#Select battery string 2
		GPIO.output("P9_14", GPIO.HIGH)	#A00	
		
		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 1
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN

		time.sleep(pause_time)

		value_5 = ADC.read("AIN1")	#Read pin 37
		voltage_5 = value_5 * 1.8
		battery_5 = voltage_5 * scale_2

		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 2
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_6 = ADC.read("AIN1")
		voltage_6 = value_6 * 1.8
		battery_6 = voltage_6 * scale_2

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 3
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_7 = ADC.read("AIN1")
		voltage_7 = value_7 * 1.8
		battery_7 = voltage_7 * scale_2

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 4
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_8 = ADC.read("AIN1")
		voltage_8 = value_8 * 1.8
		battery_8 = voltage_8 * scale_2

############################################################################################################################################################
		GPIO.output("P9_12", GPIO.LOW)	#A11	#Select battery string 2
		GPIO.output("P9_14", GPIO.HIGH)	#A00	
		
		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 1
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN

		time.sleep(pause_time)

		value_5 = ADC.read("AIN1")	#Read pin 37
		voltage_5 = value_5 * 1.8
		battery_5 = voltage_5 * scale_2

		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 2
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_6 = ADC.read("AIN1")
		voltage_6 = value_6 * 1.8
		battery_6 = voltage_6 * scale_2

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 3
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_7 = ADC.read("AIN1")
		voltage_7 = value_7 * 1.8
		battery_7 = voltage_7 * scale_2

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 4
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_8 = ADC.read("AIN1")
		voltage_8 = value_8 * 1.8
		battery_8 = voltage_8 * scale_2

############################################################################################################################################################
		GPIO.output("P9_12", GPIO.HIGH)	#A11	#Select battery string 3
		GPIO.output("P9_14", GPIO.LOW)	#A00	
		
		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 1
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN

		time.sleep(pause_time)

		value_9 = ADC.read("AIN1")	#Read pin 37
		voltage_9 = value_9 * 1.8
		battery_9 = voltage_9 * scale_2

		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 2
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_10 = ADC.read("AIN1")
		voltage_10 = value_10 * 1.8
		battery_10 = voltage_10 * scale_2

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 3
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_11 = ADC.read("AIN1")
		voltage_11 = value_11 * 1.8
		battery_11 = voltage_11 * scale_2

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 4
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_12 = ADC.read("AIN1")
		voltage_12 = value_12 * 1.8
		battery_12 = voltage_12 * scale_2

############################################################################################################################################################
		GPIO.output("P9_12", GPIO.HIGH)	#A11	#Select battery string 4
		GPIO.output("P9_14", GPIO.HIGH)	#A00	
		
		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 1
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN

		time.sleep(pause_time)

		value_13 = ADC.read("AIN1")	#Read pin 37
		voltage_13 = value_13 * 1.8
		battery_13 = voltage_13 * scale_2

		GPIO.output("P9_18",GPIO.LOW)	#A1	#Case 2
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_14 = ADC.read("AIN1")
		voltage_14 = value_14 * 1.8
		battery_14 = voltage_14 * scale_2

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 3
		GPIO.output("P9_22",GPIO.LOW)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_15 = ADC.read("AIN1")
		voltage_15 = value_15 * 1.8
		battery_15 = voltage_15 * scale_2

		GPIO.output("P9_18",GPIO.HIGH)	#A1	#Case 4
		GPIO.output("P9_22",GPIO.HIGH)	#A0
		GPIO.output("P9_16",GPIO.HIGH)	#EN
		
		time.sleep(pause_time)

		value_16 = ADC.read("AIN1")
		voltage_16 = value_16 * 1.8
		battery_16 = voltage_16 * scale_2

############################################################################################################################################################
		
#		battery_1 = battery_1	#Set values to 0 if not in use
#		battery_2 = battery_2
#		battery_3 = battery_3
#		battery_4 = battery_4
#		battery_5 = battery_5
#		battery_6 = battery_6
#		battery_7 = 0
#		battery_8 = 0
#		battery_9 = battery_9
#		battery_10 = battery_10
#		battery_11 = 0
#		battery_12 = 0
#		battery_13 = battery_13
#		battery_14 = battery_14
#		battery_15 = 0
#		battery_16 = 0
#		current_1 = current_1
	
		writer.writerow({"timestamp": "%s" % int(time.time()) ,"time": " %s" % strftime("%H:%M",localtime()),"Battery 1 (V)": " %s" % battery_1,"Battery 2 (V)": " %s" % battery_2,
"Battery 3 (V)": " %s" % battery_3,"Battery 4 (V)": " %s" % battery_4,"Battery 5 (V)": " %s" % battery_5,"Battery 6 (V)": " %s" % battery_6,"Battery 7 (V)": " %s" % battery_7,
"Battery 8 (V)": " %s" % battery_8,"Battery 9 (V)": " %s" % battery_9,"Battery 10 (V)": " %s" % battery_10,"Battery 11 (V)": " %s" % battery_11,"Battery 12 (V)": " %s" % battery_12,
"Current 1": " %s" % current_1,"FIO5": " %s" % " 0","FIO6": " %s" % " 0","FIO7": " %s" % " 0","Temp": " %s" % " 0"})	#Write new data to file

		print "System Time : " + str(int(time.time()))
		print "Actual Time : " + str(strftime("%H:%M", localtime()))
		print "Battery 1 (V) : " + str(battery_1)
		print "Battery 2 (V) : " + str(battery_2)
		print "Battery 3 (V) : " + str(battery_3)
		print "Battery 4 (V) : " + str(battery_4)
		print "Battery 5 (V) : " + str(battery_5)
		print "Battery 6 (V) : " + str(battery_6)
		print "Battery 7 (V) : " + str(battery_7)
		print "Battery 8 (V) : " + str(battery_8)
		print "Battery 9 (V) : " + str(battery_9)
		print "Battery 10 (V): " + str(battery_10)
		print "Battery 11 (V): " + str(battery_11)
		print "Battery 12 (V): " + str(battery_12)
		print "Battery 13 (V): " + str(battery_13)
		print "Battery 14 (V): " + str(battery_14)
		print "Battery 15 (V): " + str(battery_15)
		print "Battery 16 (V): " + str(battery_16)
		print "Current (A) : " + str(current_1) + "\n"

		if strftime("%H:%M", localtime()) == "23:59":
			collecting = 0

		time.sleep(wait_time - 20*pause_time)	#Wait indicated time


ATT00001.htm

