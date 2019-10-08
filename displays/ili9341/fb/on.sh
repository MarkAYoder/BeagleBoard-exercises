#!/bin/bash
# From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83

# Connect the display before running this.
export LED=51         # P9_16

# This is for the Black SPI 0
export RESET=12     # RESET - P9_20
export DC=13        # D/C   - P9_19
export CS=5         # CS    - P9_17
export BUS=1        # SPI bus 0
# This is for the Black SPI 1
# export RESET=117    # RESET - P9_25
# export DC=115       # D/C   - P9_27
# export CS=113       # CS    - P9_28
# export BUS=2        # SPI bus 1
# This is for the AI SPI 2 & 3
# export RESET=177    # RESET - P9_25
# export DC=111       # D/C   - P9_27
# export CS=207       # CS    - P9_28
# export BUS=3        # SPI bus 2 or 3
# This is for the Pocket SPI 0
# export RESET=57     # RESET - P2.06
# export DC=58        # D/C   - P2.04
# export CS=5         # CS    - P1.06
# export BUS=1        # SPI bus 0

sudo bash << EOF
    # Remove the framebuffer modules
    if lsmod | grep -q 'fbtft_device ' ; then rmmod fbtft_device;  fi
    if lsmod | grep -q 'fb_ili9341 '   ; then rmmod --force fb_ili9341;    fi
    if lsmod | grep -q 'fbtft '        ; then rmmod --force fbtft;         fi

    # Set the pinmuxes for the display
    # Black SPI 0
    config-pin P9_19 gpio   # D/C
    config-pin P9_20 gpio   # RESET
    config-pin P9_18 spi    # spi 0_d1 MOSI
    config-pin P9_21 spi    # spi 0_d0 MISO
    config-pin P9_22 spi_sclk # spi 0_sclk
    config-pin P9_17 spi_cs # spi 0_cs0
    
    # Black SPI 1
    # config-pin P9_27 gpio   # D/C
    # config-pin P9_25 gpio   # RESET
    # config-pin P9_30 spi    # spi 1_d1 MOSI
    # config-pin P9_29 spi    # spi 1_d0 MISO
    # config-pin P9_31 spi_sclk # spi 1_sclk
    # config-pin P9_28 spi_cs # spi 1_cs0
    
    # LED pin, turn on
    ./LCD-backlight.py
    
    sleep 0.1
    
    # Insert the framebuffer modules
    # Change busnum to the SPI bus number PLUS 1
    modprobe fbtft_device name=adafruit28 busnum=$BUS rotate=180 gpios=reset:$RESET,dc:$DC cs=0

    # Turn off cursor
    while [ ! -e /dev/fb0 ]
    do
      echo Waiting for /dev/fb0
      sleep 1
    done

    # echo 0 > /sys/class/graphics/fbcon/cursor_blink 

EOF
