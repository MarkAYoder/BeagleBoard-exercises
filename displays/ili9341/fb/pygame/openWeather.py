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
from datetime import datetime

# Get outdoor temp and forcast from wunderground
key='6a2db5c8171494bce131dc69af6f34b9'
city='brazil,indiana'

urlWeather = "http://api.openweathermap.org/data/2.5/weather?q=" + city + "&units=imperial" + "&appid=" + key
try:
    r = requests.get(urlWeather)
    if(r.status_code==200):
        # print("headers: ", r.headers)
        # print("text: ", r.text)
        # print("json: ", r.json())
        weather = r.json()
        print(weather['name'], "Summary: ", weather['weather'][0]['description'])
        print("Temp: ", weather['main']['temp'])
        print("Max: ", weather['main']['temp_min'])
        print("Min: ", weather['main']['temp_max'])
        print("Humid:", weather['main']['humidity'])
        # print("Low:  ", weather['forecast']['simpleforecast']['forecastday'][0]['low']['fahrenheit'])
        # print("High: ", weather['forecast']['simpleforecast']['forecastday'][0]['high']['fahrenheit'])
        print("Wind:\n\tAve: ", weather['wind']['speed'])
        print("\tDirection: ", weather['wind']['deg'])

# if you encounter a "year is out of range" error the timestamp
# may be in milliseconds, try `ts /= 1000` in that case
        rise = weather['sys']['sunrise'] + weather['timezone']
        print("sunrise: " + datetime.utcfromtimestamp(rise).strftime('%Y-%m-%d %H:%M:%S'))
        set  = weather['sys']['sunset'] + weather['timezone']
        print("sunset:  " + datetime.utcfromtimestamp(set).strftime('%Y-%m-%d %H:%M:%S'))

        # print("All : ", weather)
    else:
        print("status_code: ", r.status_code)
except:
    print("Unexpected error:", sys.exc_info()[0])