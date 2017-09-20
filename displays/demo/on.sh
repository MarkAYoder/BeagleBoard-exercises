#!/bin/sh
# From: https://gist.github.com/jadonk/0e4a190fc01dc5723d1f183737af1d83

# Connect the display before running this.

sudo bash << EOF
    # remove the framebuffer modules
    rmmod --force fb_ili9341
    rmmod --force fbtft
    rmmod --force fbtft_device

    # unexport poins 49 and 57 so the framebuffer can use them
    # echo 49 > /sys/class/gpio/unexport # RESET - V14 - GP0_4
    # echo 57 > /sys/class/gpio/unexport # D/C - U16 - GP0_3
    echo 113 > /sys/class/gpio/unexport # RESET - V14 - GP0_6
    echo 116 > /sys/class/gpio/unexport # D/C - U16 - GP0_5
        
    # Set the pinmuxes for the display
    # echo gpio > /sys/devices/platform/ocp/ocp\:P9_23_pinmux/state # RESET - V14 - GP0_4
    # echo gpio > /sys/devices/platform/ocp/ocp\:U16_pinmux/state # D/C     - U16 - GP0_3
    echo gpio > /sys/devices/platform/ocp/ocp\:P9_28_pinmux/state # RESET- P9_28 - GP0_6
    echo gpio > /sys/devices/platform/ocp/ocp\:D13_pinmux/state   # D/C  - D13 - GP0_5
    echo spi > /sys/devices/platform/ocp/ocp\:P9_31_pinmux/state  # SCLK - A13 - S1.1_5
    echo spi > /sys/devices/platform/ocp/ocp\:P9_29_pinmux/state  # MISO - B13 - S1.1_4
    echo spi > /sys/devices/platform/ocp/ocp\:P9_30_pinmux/state  # MOSI - D12 - S1.1_3
    
    # Set chip select  H18 is cs 0,  C18 is cs 1
    echo 29 > /sys/class/gpio/unexport # CS - H18
    echo spi > /sys/devices/platform/ocp/ocp\:H18_pinmux/state # CS - H18 - S1.1_6
    # echo 7 > /sys/class/gpio/unexport # CS - C18
    # echo spi > /sys/devices/platform/ocp/ocp\:C18_pinmux/state # CS - C18 - S1.2_6
    
    sleep 1
    
    # Insert the framebuffer modules
    # modprobe fbtft_device name=adafruit28 busnum=1 rotate=90 gpios=reset:49,dc:57
    modprobe fbtft_device name=adafruit28 busnum=1 rotate=270 gpios=reset:113,dc:116 cs=0
EOF
