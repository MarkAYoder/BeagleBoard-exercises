#!/bin/bash
# From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83

# Connect the display before running this.

export GPIO=/sys/class/gpio
export OCP=/sys/devices/platform/ocp
export LED=49         # P9_23
# This is for the Blue
# export RESET=113  # RESET - V14 - GP0_6
# export DC=116     # D/C - U16 - GP0_3
# export CS=29      # CS - H18
# This is for the Black SPI 1
# export RESET=115  # RESET - P9_27
# export DC=14      # D/C - U16 - P9_26
# export CS=113     # CS - H18
# This is for the Black SPI 0
export RESET=12     # RESET - P9_20
export DC=13        # D/C   - P9_19
export CS=5         # CS    - P9_17

sudo bash << EOF
    # Remove the framebuffer modules
    if lsmod | grep -q 'fbtft_device ' ; then rmmod fbtft_device;  fi
    if lsmod | grep -q 'fb_ili9341 '   ; then rmmod --force fb_ili9341;    fi
    if lsmod | grep -q 'fbtft '        ; then rmmod --force fbtft;         fi

    # unexport pins 49 and 57 so the framebuffer can use them
    # echo 49 > $GPIO/unexport # RESET - V14 - GP0_4
    # echo 57 > $GPIO/unexport # D/C - U16 - GP0_3
    # Doesn't seem to need to unexport these
    # if [ -d $GPIO/gpio$RESET ]; then echo $RESET > $GPIO/unexport; fi
    # if [ -d $GPIO/gpio$DC    ]; then echo $DC    > $GPIO/unexport; fi

    # Set the pinmuxes for the display
    # echo gpio > $OCP/ocp\:P9_23_pinmux/state # RESET - V14 - GP0_4
    # echo gpio > $OCP/ocp\:U16_pinmux/state # D/C     - U16 - GP0_3
    
    # echo gpio > $OCP/ocp\:P9_28_pinmux/state # RESET- P9_28 - GP0_6
    # echo gpio > $OCP/ocp\:D13_pinmux/state   # D/C  - D13 - GP0_5
    # echo spi  > $OCP/ocp\:P9_31_pinmux/state  # SCLK - A13 - S1.1_5
    # echo spi  > $OCP/ocp\:P9_29_pinmux/state  # MISO - B13 - S1.1_4
    # echo spi  > $OCP/ocp\:P9_30_pinmux/state  # MOSI - D12 - S1.1_3
    config-pin P9_19 gpio   # D/C
    config-pin P9_20 gpio   # RESET
    config-pin P9_18 spi    # spi 0_d1 MOSI
    config-pin P9_21 spi    # spi 0_d0 MISO
    config-pin P9_22 spi_sclk # spi 0_sclk
    config-pin P9_17 spi_cs # spi 0_cs0
    
    # Set chip select  H18 is cs 0,  C18 is cs 1
    # if [ -d $GPIO/gpio$CS ]; then echo $CS    > $GPIO/unexport; fi
    # echo spi > $OCP/ocp\:H18_pinmux/state # CS - H18 - S1.1_6
    # echo spi > $OCP/ocp\:C18_pinmux/state # CS - C18 - S1.2_6
    
    # LED pin, turn on
    echo gpio > $OCP/ocp\:P9_23_pinmux/state # LED- P9_23 - GP0_4
    if [ ! -d $GPIO/gpio$LED    ]; then echo $LED    > $GPIO/export; fi
    echo out > $GPIO/gpio$LED/direction
    echo 1   > $GPIO/gpio$LED/value
    
    sleep 0.5
    
    # Insert the framebuffer modules
    # modprobe fbtft_device name=adafruit28 busnum=1 rotate=90 gpios=reset:49,dc:57
    modprobe fbtft_device name=adafruit28 busnum=1 rotate=90 gpios=reset:$RESET,dc:$DC cs=0
EOF
