#!/usr/bin/env python3
# Displays an analog clock on an LCD display
# From: https://learn.adafruit.com/pi-video-output-using-pygame/pointing-pygame-to-the-framebuffer

import os
import pygame
import time
import math

class pyclock :
    screen = None;
    
    def __init__(self):
        "Ininitializes a new pygame screen using the framebuffer"
        # Based on "Python GUI in Linux frame buffer"
        # http://www.karoltomala.com/blog/?p=679
        # disp_no = os.getenv("DISPLAY")
        # if disp_no:
        #     print("I'm running under X display = " + format(disp_no))
        
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
        xmax = pygame.display.Info().current_w
        ymax = pygame.display.Info().current_h
        
        print("xmay, ymax: ", xmax, "x", ymax)
        
        # Set center of clock
        
        # https://stackoverflow.com/questions/20842801/how-to-display-text-in-pygame
        myfont = pygame.font.SysFont('Comic Sans MS', 30)

        xcent = int(xmax/2)
        ycent = int(ymax/2)
        print("xcent, ycent: ", xcent, "x", ycent)
        
        minScale = 0.85     # Size of minute hand relative to second
        hourScale = 0.5
        width = 2           # Width of hands
        
        rad = 100   # Radius
        len = 15    # Length of ticks
        
        backgroundC = (173,216,230)
        faceC = (0, 0, 255)

        self.screen.fill(backgroundC)
        # Draw face
        pygame.draw.circle(self.screen, faceC, (xcent, ycent), rad, 1)
        # Put tick marks inside the circle
        for i in range(12):
            ang = i*math.pi/6
            out_pos= (xcent+rad*math.cos(ang),       ycent-rad*math.sin(ang))
            in_pos = (xcent+(rad-len)*math.cos(ang), ycent-(rad-len)*math.sin(ang))
            pygame.draw.line(self.screen, faceC, in_pos, out_pos, 2)

        oldAngS = 0     # Remeber where hands were so they can be removed
        oldAngM = 0
        oldAngH = 0
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
            textsurface = myfont.render(
                str(hour)+":"+str(minute)+":"+str(second)+"  ", 
                False, (0, 0, 0), backgroundC)
            self.screen.blit(textsurface,(0, 0))

            pygame.display.update()
            pygame.time.wait(1000)

# Create an instance of the clock class
clock = pyclock()
clock.drawClock()
