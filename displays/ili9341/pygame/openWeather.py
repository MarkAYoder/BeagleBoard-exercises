#!/usr/bin/env python3
# // Displays temp and humidity and forecast from openweathermap
# // 
# // Gets data from weather underground.
# // Displays as
# //  Temp:
# //  Hum:
# //  lo:
# //  hi:
# //      time
# // Where Temp is the outdoor temp from openweathermap and lo and hi are the 
# //  forecasted low and hi temps.

import requests
import sys
from datetime import datetime

# Get outdoor temp and forcast from openweathermap
params = {
    'appid': '6a2db5c8171494bce131dc69af6f34b9',
    # 'city': 'brazil,indiana',
    'exclude': "minutely,hourly",
    'lat':  '39.52',
    'lon': '-87.12',
    'units': 'imperial'
    }
urlWeather = "http://api.openweathermap.org/data/2.5/onecall"
print(urlWeather)
try:
    r = requests.get(urlWeather, params=params)
    if(r.status_code==200):
        # print("headers: ", r.headers)
        # print("text: ", r.text)
        # print("json: ", r.json())
        weather = r.json()
        print("Summary: ", weather['current']['weather'][0]['description'])
        print("Temp: ", weather['current']['temp'])
        print("Humid:", weather['current']['humidity'])
        print("Wind:\n\tAve: ", weather['current']['wind_speed'])
        print("\tDirection: ", weather['current']['wind_deg'])
        print("High: ", weather['daily'][0]['temp']['max'])
        print("Low: ", weather['daily'][0]['temp']['min'])

        rise = weather['current']['sunrise'] + weather['timezone_offset']
        print("sunrise: " + datetime.utcfromtimestamp(rise).strftime('%Y-%m-%d %H:%M:%S'))
        set  = weather['current']['sunset'] + weather['timezone_offset']
        print("sunset:  " + datetime.utcfromtimestamp(set).strftime('%Y-%m-%d %H:%M:%S'))

        # print("All : ", weather)
    else:
        print("status_code: ", r.status_code)
    # print(r.url)
except Exception as e:
    print("Oops!", e.__class__, "occurred.")
    print("Unexpected error:", sys.exc_info()[0])
    print(r)
    print(r.url)
        