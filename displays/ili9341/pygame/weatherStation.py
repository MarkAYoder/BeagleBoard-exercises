#!/usr/bin/env python3
# // Displays temp and humidity and forecast from wunderground
# // 
# // Gets data from weather underground.
# // Displays as
# //  Temp:
# //  Hum:
# //  lo:
# //  hi:
# //      time
# // Where Temp is the outdoor temp from wunderground and lo and hi are the 
# //  forecasted low and hi temps.

import requests
import sys

# Get outdoor temp and forcast from wunderground
urlWeather = "http://api.wunderground.com/api/ec7eb641373d9256/yesterday/history/conditions/forecast/q/IN/Brazil.json"
try:
    r = requests.get(urlWeather)
    if(r.status_code==200):
        # print("headers: ", r.headers)
        # print("text: ", r.text)
        # print("json: ", r.json())
        weather = r.json()
        print("Temp: ", weather['current_observation']['temp_f'])
        print("Yesterday Max: ", weather['history']['dailysummary'][0]['maxtempi'])
        print("Yesterday Min: ", weather['history']['dailysummary'][0]['mintempi'])
        print("Humid:", weather['current_observation']['relative_humidity'])
        print("Low:  ", weather['forecast']['simpleforecast']['forecastday'][0]['low']['fahrenheit'])
        print("High: ", weather['forecast']['simpleforecast']['forecastday'][0]['high']['fahrenheit'])
        print("Wind:\n\tAve: ", weather['forecast']['simpleforecast']['forecastday'][0]['avewind']['mph'])
        print("\tMax: ", weather['forecast']['simpleforecast']['forecastday'][0]['maxwind']['mph'])
        # print("All : ", weather)
    else:
        print("status_code: ", r.status_code)
except:
    print("Unexpected error:", sys.exc_info()[0])