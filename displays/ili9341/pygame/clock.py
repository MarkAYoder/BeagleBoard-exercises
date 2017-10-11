#!/usr/bin/env python3
# From: https://learn.adafruit.com/pi-video-output-using-pygame/pointing-pygame-to-the-framebuffer
import os
import pygame
import time
import random
import math
from datetime import datetime
import time

class pyclock :
    screen = None;
    
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
        # Render the screen
        # pygame.display.update()

    def __del__(self):
        "Destructor to make sure pygame shuts down, etc."

    def test(self):
        # Fill the screen with red (255, 0, 0)
        red = (255, 0, 0)
        self.screen.fill(red)
        pygame.draw.rect(self.screen, (0, 128, 230), pygame.Rect(30, 30, 60, 60))
        # Update the display
        pygame.display.update()
        
    def drawGraticule(self):
        "Renders an empty graticule"
        # The graticule is divided into 10 columns x 8 rows
        # Each cell is 50x40 pixels large, with 5 subdivisions per
        # cell, meaning 10x8 pixels each.  Subdivision lines are
        # displayed on the central X and Y axis
        # Active area = 10,30 to 510,350 (500x320 pixels)
        borderColor = (255, 255, 255)
        lineColor = (64, 64, 64)
        subDividerColor = (128, 128, 128)
        # Outer border: 2 pixels wide
        pygame.draw.rect(self.screen, borderColor, (8,28,504,324), 2)
        # Horizontal lines (40 pixels apart)
        for i in range(0, 7):
            y = 70+i*40
            pygame.draw.line(self.screen, lineColor, (10, y), (510, y))
        # Vertical lines (50 pixels apart)
        for i in range(0, 9):
            x = 60+i*50
            pygame.draw.line(self.screen, lineColor, (x, 30), (x, 350))
        # Vertical sub-divisions (8 pixels apart)
        for i in range(1, 40):
            y = 30+i*8
            pygame.draw.line(self.screen, subDividerColor, (258, y), (262, y))
        # Horizontal sub-divisions (10 pixels apart)
        for i in range(1, 50):
            x = 10+i*10
            pygame.draw.line(self.screen, subDividerColor, (x, 188), (x, 192))
        pygame.display.update()
        
    def drawClock(self):
        xmax = pygame.display.Info().current_w
        ymax = pygame.display.Info().current_h
        
        print("xmay, ymax: ", xmax, "x", ymax)
        
        # Set center of clock
        xcent = int(xmax/2)
        ycent = int(ymax/2)
        print("xcent, ycent: ", xcent, "x", ycent)
        
        minScale = 0.85     # Size of minute hand relative to second
        hourScale = 0.5
        
        rad = 100   # Radius
        len = 10    # Length of ticks
        
        backgroundC = (173,216,230)
        faceC = (0, 0, 255)

        self.screen.fill(backgroundC)
        # Draw face
        pygame.draw.circle(self.screen, faceC, (xcent, ycent), rad, 1)
        #put tick marks inside the circle
        for i in range(12):
            ang = i*math.pi/6
            out_pos= (xcent+rad*math.cos(ang),       ycent-rad*math.sin(ang))
            in_pos = (xcent+(rad-len)*math.cos(ang), ycent-(rad-len)*math.sin(ang))
            pygame.draw.line(self.screen, faceC, in_pos, out_pos, 2)

        oldAngS = 0
        oldAngM = 0
        oldAngH = 0
        while True:
            currentTime = time.localtime()
            hour = currentTime[3]%12
            minute = currentTime[4]
            second = currentTime[5]
            print("Time: ", hour, ":", minute, ":", second)
            
            # Erase second hand
            pygame.draw.line(self.screen, backgroundC, (xcent, ycent), 
                (xcent+rad*math.cos(oldAngS), ycent-rad*math.sin(oldAngS)), 
                1)
            # Erase minute hand
            pygame.draw.line(self.screen, backgroundC, (xcent, ycent), 
                (xcent+minScale*rad*math.cos(oldAngM), ycent-minScale*rad*math.sin(oldAngM)), 
                1)
            # Erase hour hand
            pygame.draw.line(self.screen, backgroundC, (xcent, ycent), 
                (xcent+hourScale*rad*math.cos(oldAngH), ycent-hourScale*rad*math.sin(oldAngH)), 
                1)
                
            # Draw second hand
            angS = math.pi/2-2*math.pi*second/60
            pygame.draw.line(self.screen, faceC, (xcent, ycent), 
                (xcent+rad*math.cos(angS), ycent-rad*math.sin(angS)), 
                1)
            # minute hand
            angM = math.pi/2-2*math.pi*minute/60
            pygame.draw.line(self.screen, faceC, (xcent, ycent), 
                (xcent+minScale*rad*math.cos(angM), ycent-minScale*rad*math.sin(angM)), 
                1)
            # hour hand
            angM = math.pi/2-2*math.pi*hour/12
            pygame.draw.line(self.screen, faceC, (xcent, ycent), 
                (xcent+hourScale*rad*math.cos(angM), ycent-hourScale*rad*math.sin(angM)), 
                1)

            oldAngS = angS
            oldAngM = angM
            
            pygame.display.update()
            pygame.time.wait(1000)

# Create an instance of the clock class
clock = pyclock()
# clock.test()
# clock.drawGraticule()
clock.drawClock()
time.sleep(100)
