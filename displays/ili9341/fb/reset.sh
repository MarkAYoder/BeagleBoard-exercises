#!/bin/sh

export GPIO=/sys/class/gpio
export OCP=/sys/devices/platform/ocp
export LED=49
export RESET=113    # RESET - V14 - GP0_6
export DC=116       # D/C - U16 - GP0_3
export CS=29        # CS - H18

sudo bash << EOF
    # Save contents of framebuffer
    cat /dev/fb0 > /tmp/fb0
    # Disable the framebuffer
    echo Disabling framebuffer
    if lsmod | grep -q 'fbtft_device ' ; then rmmod fbtft_device;  fi
    sleep 1
    # Get access to the RESET pin
    if [ ! -d $GPIO/gpio$RESET ]; then echo $RESET > $GPIO/export; fi
    echo Toggling RESET
    sleep 1
    # Toggle it
    echo out > $GPIO/gpio$RESET/direction
    echo 0   > $GPIO/gpio$RESET/value
    echo 1   > $GPIO/gpio$RESET/value
    
    # Remove access so the framebuffer can use it
    echo $RESET  > $GPIO/unexport # RESET - V14 - GP0_PIN4

    # Fire up the framebuffer
    echo Firing up framebuffer
    sleep 1
    # modprobe fbtft_device name=adafruit28 busnum=1 rotate=90 gpios=reset:49,dc:57
    modprobe fbtft_device name=adafruit28 busnum=1 rotate=90 gpios=reset:$RESET,dc:$DC cs=0

    # Restore the image
    cat /tmp/fb0 > /dev/fb0
EOF