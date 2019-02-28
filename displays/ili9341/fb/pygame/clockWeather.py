#!/usr/bin/env python3
# Displays an analog clock on an LCD display
# Also displays current weather and forcast
# From: https://learn.adafruit.com/pi-video-output-using-pygame/pointing-pygame-to-the-framebuffer

import os
import pygame
import time
import math
import sys

import requests     # For getting weather
from PIL import Image
# import shutil

class pyclock :
    screen = None

    def __init__(self):
        "Ininitializes a new pygame screen using the framebuffer"
        # Based on "Python GUI in Linux frame buffer"
        # http://www.karoltomala.com/blog/?p=679
        disp_no = os.getenv("DISPLAY")
        if disp_no:
            print("I'm running under X display = " + format(disp_no))
        
        # Check which frame buffer drivers are available
        # Start with fbcon since directfb hangs with composite output
        drivers = ['fbcon', 'directfb', 'svgalib']
        found = False
        for driver in drivers:
            # Make sure that SDL_VIDEODRIVER is set
            if not os.getenv('SDL_VIDEODRIVER'):
                os.putenv('SDL_VIDEODRIVER', driver)
            try:
                pygame.display.init()
            except pygame.error:
                print('Driver: ' + format(driver) + ' failed.')
                continue
            found = True
            break
    
        if not found:
            raise Exception('No suitable video driver found!')
        
        size = (pygame.display.Info().current_w, pygame.display.Info().current_h)
        print("Framebuffer size: ", size[0], "x", size[1])
        self.screen = pygame.display.set_mode(size, pygame.FULLSCREEN)
        # Clear the screen to start
        self.screen.fill((0, 0, 0))   
        # Turn off cursor
        pygame.mouse.set_visible(False)
        # Initialise font support
        pygame.font.init()

    def __del__(self):
        "Destructor to make sure pygame shuts down, etc."
        
    def drawClock(self):
        # icon is the url for the icon to be displayed
        # yCount is how many icons down to display.  I'm assuming all icon are the same height
        def displayIcon(icon, title, yCount):
            print("displayIcon(" + icon + ", " + str(yCount) + ")")
            file = "/tmp/" + icon.split('/')[-1]
            # See if icon is already in /tmp
            # print("Getting: " + icon)
            try:
                image = pygame.image.load(file)
                print("Found in: " + file)
            # We don't have it already, so get it from the weather site
            except:
                r = requests.get(icon, stream=True)
                r.raw.decode_content = True # handle spurious Content-Encoding
                im = Image.open(r.raw)
                # print(im.format, im.mode, im.size)
                im.save(file)
                image = pygame.image.load(file)

            # Blank out background
            pygame.draw.rect(self.screen, backgroundC, 
                    (xmax-image.get_width(), yCount*image.get_height(),
                    image.get_width(), yCount*image.get_height()), 0)
            # print("title: " + title)
            textsurface = myfont.render(title[:3]+"   ", False, (0, 0, 0), backgroundC)
            self.screen.blit(textsurface,(xmax-80, yCount*image.get_height()))
            # print("Size: " + str(image.get_size()))
            self.screen.blit(image, (xmax-image.get_width(), yCount*image.get_height()))
                
        # https://www.wunderground.com/weather/api/d/docs
        key = "ec7eb641373d9256"
        urlWeather = "http://api.wunderground.com/api/" + key + "/conditions/forecast/history/yesterday/q/IN/Brazil.json"
        urlWeather = "http://api.wunderground.com/api/" + key + "/conditions/forecast/q/IN/Brazil.json"
        # Need to use keyword 'yesterday' so ['history']['dailysummary'][0]['mintempi']
        #  gets yesterdays min and max

        xmax = pygame.display.Info().current_w
        ymax = pygame.display.Info().current_h
        
        print("xmay, ymax: ", xmax, "x", ymax)
        
        # Set center of clock

        xcent = int(xmax/2)
        ycent = int(ymax/2)
        print("xcent, ycent: ", xcent, "x", ycent)
        
        minScale = 0.85     # Size of minute hand relative to second
        hourScale = 0.5
        width = 3           # Width of hands
        
        rad = 70   # Radius
        len = 15    # Length of ticks
        
        backgroundC = (173,216,230)
        faceC = (0, 0, 255)

        # https://stackoverflow.com/questions/20842801/how-to-display-text-in-pygame
        myfont = pygame.font.SysFont('FreeSerif', 25, True)
        myfontBig = pygame.font.SysFont('FreeSerif', 40, True)

        self.screen.fill(backgroundC)
        # Draw face
        pygame.draw.circle(self.screen, faceC, (xcent, ycent), rad, 2)
        # Put tick marks inside the circle
        for i in range(12):
            ang = i*math.pi/6
            out_pos= (xcent+rad*math.cos(ang),       ycent-rad*math.sin(ang))
            in_pos = (xcent+(rad-len)*math.cos(ang), ycent-(rad-len)*math.sin(ang))
            pygame.draw.line(self.screen, faceC, in_pos, out_pos, 2)

        oldAngS = 0     # Remeber where hands were so they can be removed
        oldAngM = 0
        oldAngH = 0
        first   = True  # First time through the loop
        while True:
            currentTime = time.localtime()
            hour = currentTime[3]%12    # Convert to 12 hour time
            minute = currentTime[4]
            second = currentTime[5]

            # print("Time: ", hour, ":", minute, ":", second)
            
            # Erase second hand
            pygame.draw.line(self.screen, backgroundC, (xcent, ycent), 
                (xcent+(rad-len)*math.cos(oldAngS), ycent-(rad-len)*math.sin(oldAngS)), 
                width)
            # Erase minute hand
            pygame.draw.line(self.screen, backgroundC, (xcent, ycent), 
                (xcent+minScale*rad*math.cos(oldAngM), ycent-minScale*rad*math.sin(oldAngM)), 
                width)
            # Erase hour hand
            pygame.draw.line(self.screen, backgroundC, (xcent, ycent), 
                (xcent+hourScale*rad*math.cos(oldAngH), ycent-hourScale*rad*math.sin(oldAngH)), 
                width)
                
            # Draw second hand
            angS = math.pi/2-2*math.pi*second/60
            pygame.draw.line(self.screen, faceC, (xcent, ycent), 
                (xcent+(rad-len)*math.cos(angS), ycent-(rad-len)*math.sin(angS)), 
                width)
            # minute hand
            angM = math.pi/2-2*math.pi*minute/60 + angS/60
            pygame.draw.line(self.screen, faceC, (xcent, ycent), 
                (xcent+minScale*rad*math.cos(angM), ycent-minScale*rad*math.sin(angM)), 
                width)
            # hour hand
            angH = math.pi/2-2*math.pi*hour/12 + angM/12
            pygame.draw.line(self.screen, faceC, (xcent, ycent), 
                (xcent+hourScale*rad*math.cos(angH), ycent-hourScale*rad*math.sin(angH)), 
                width)

            oldAngS = angS      # Remember current locations
            oldAngM = angM
            oldAngH = angH
            
            # Display the time in digital form too
            # print("myfont.get_linesize(): " + str(myfont.get_linesize()))
            # print("Time: " + time.strftime("%I:%M:%S"))
            textsurface = myfont.render(
                time.strftime("%I:%M:%S")+"  ", False, (0, 0, 0), backgroundC)
            # Print time centered at top of screen
            self.screen.blit(textsurface,(xmax/2-textsurface.get_width()/2, 0))

            # Get outdoor temp and forcast from wunderground
            if first or ((minute%15 == 0) and (second%60==5)):
                first = False
            # if True:
                print("Getting weather")

                try:
                    r = requests.get(urlWeather)
                    if(r.status_code==200):
                        # Print the weather on the LCD
                        # print("headers: ", r.headers)
                        # print("text: ", r.text)
                        # print("json: ", r.json())
                        weather = r.json()
                        # print("Temp: ", weather['current_observation']['temp_f'])
                        # print("Humid:", weather['current_observation']['relative_humidity'])
                        # print("Low:  ", weather['forecast']['simpleforecast']['forecastday'][0]['low']['fahrenheit'])
                        # print("High: ", weather['forecast']['simpleforecast']['forecastday'][0]['high']['fahrenheit'])
                        # print("forecast: ", weather['forecast'])
                        textsurface = myfontBig.render(
                            str(weather['current_observation']['temp_f']) + "  ",
                            False, (0, 0, 0), backgroundC)
                        self.screen.blit(textsurface,(0, 0))
                        
                        textsurface = myfont.render(
                            str(weather['current_observation']['relative_humidity']),
                            False, (0, 0, 0), backgroundC)
                        self.screen.blit(textsurface,(0, myfontBig.get_linesize()))
                        
                        textsurface = myfont.render(
                            # "Time: " + weather['current_observation']['local_time_rfc822'] +
                            "Lo: "+str(weather['forecast']['simpleforecast']['forecastday'][0]['low']['fahrenheit']),
                            False, (0, 0, 0), backgroundC)
                        self.screen.blit(textsurface,(0,  myfontBig.get_linesize()+myfont.get_linesize()))
                        
                        textsurface = myfont.render(
                            "Hi: " +str(weather['forecast']['simpleforecast']['forecastday'][0]['high']['fahrenheit']),
                            False, (0, 0, 0), backgroundC)
                        self.screen.blit(textsurface,(0,  myfontBig.get_linesize()+2*myfont.get_linesize()))
                        
                        tmp = weather['forecast']['simpleforecast']['forecastday'][0]
                        textsurface = myfont.render(
                           "Wind: " + tmp['avewind']['dir'] + " " + str(tmp['avewind']['mph']) + " to " + str(tmp['maxwind']['mph']) + "   ",
                            False, (0, 0, 0), backgroundC)
                        self.screen.blit(textsurface,(0,ymax-1*myfont.get_linesize()))
                        
                        # textsurface = myfont.render(
                        #     "Yesterday: "
                        #     +weather['history']['dailysummary'][0]['mintempi']
                        #     +"/"+weather['history']['dailysummary'][0]['maxtempi'],
                        #     False, (0, 0, 0), backgroundC)
                        # self.screen.blit(textsurface,(0,ymax-myfont.get_linesize()))
                        
                        # Get the weather icon and display it
                        # https://stackoverflow.com/questions/32853980/temporarily-retrieve-an-image-using-the-requests-library
                        displayIcon(weather['current_observation']['icon_url'], "Now", 0)
                        # Forecast has both day and night.  Here I skip half of them.
                        for i in range(0, 4, 1):
                            # displayIcon(weather['forecast']['txt_forecast']['forecastday'][i]['icon_url'], 
                            # weather['forecast']['txt_forecast']['forecastday'][i]['title'], 
                            #     i/2+1)
                            displayIcon(weather['forecast']['simpleforecast']['forecastday'][i]['icon_url'], 
                            weather['forecast']['simpleforecast']['forecastday'][i]['date']['weekday_short'], 
                                i+1)
        
                    else:
                        print("status_code: ", r.status_code)
                except:
                    print("Unexpected error:", sys.exc_info())
                    textsurface = myfont.render(
                        "Network Error",
                        False, (255, 0, 0), backgroundC)
                    self.screen.blit(textsurface,(0, ymax-myfont.get_linesize()))

            pygame.display.update()
            pygame.time.wait(1000)

# Create an instance of the clock class
clock = pyclock()
clock.drawClock()
