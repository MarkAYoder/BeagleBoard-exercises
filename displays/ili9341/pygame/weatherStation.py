#!/usr/bin/env python3
# // Displays temp and humidity and forcast from wunderground
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

# Get outdoor temp and forcast from wunderground
urlWeather = "http://api.wunderground.com/api/ec7eb641373d9256/conditions/forecast/q/IN/Brazil.json"
r = requests.get(urlWeather)
if(r.status_code==200):
    # print("headers: ", r.headers)
    # print("text: ", r.text)
    # print("json: ", r.json())
    weather = r.json()
    print("Temp: ", weather['current_observation']['temp_f'])
    print("Temp: ", weather['current_observation'])
    print("Humid:", weather['current_observation']['relative_humidity'])
    print("Low:  ", weather['forecast']['simpleforecast']['forecastday'][0]['low']['fahrenheit'])
    print("High: ", weather['forecast']['simpleforecast']['forecastday'][0]['high']['fahrenheit'])
else:
    print("status_code: ", r.status_code)
    