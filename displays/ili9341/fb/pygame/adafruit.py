#!/usr/bin/env python3
# From: https://learn.adafruit.com/pi-video-output-using-pygame/pointing-pygame-to-the-framebuffer
import os
import pygame
import time
import random

class pyscope :
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
        # os.putenv('SDL_FBDEV',   '/dev/fb0')
        os.putenv('SDL_NOMOUSE', '1')
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
        pygame.display.update()

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
        
        


# Create an instance of the PyScope class
scope = pyscope()
scope.test()
# scope.drawGraticule()
scope.drawClock()
time.sleep(10)
