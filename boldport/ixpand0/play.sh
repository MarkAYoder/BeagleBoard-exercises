# From: http://ww1.microchip.com/downloads/en/DeviceDoc/20001952C.pdf
# I'm using I2C bus 2
BUS=2
i2cdetect -y -r $BUS
# The MCP23017 appears at address 0x20
ADDR=0x20

# The switches are on GPIOA and the LEDs on GPIOB
# This assumes it starts in BANK0.
# Set GPIOA, switches, to inputs
i2cset -y -r $BUS $ADDR 0x00 0xff
# Set GPIOB to outputs
i2cset -y -r $BUS $ADDR 0x01 0x00

# Set pull-up resistors on GPIOA
i2cset -y -r $BUS $ADDR 0x0c 0xff
i2cset -y -r $BUS $ADDR 0x0d 0x00   # Turn off on GPIOB

i2cdump -y -r 0x00-0x1f 2 0x20 b

# Cycle through LEDs
for i in {0..7};
do
    i2cset -y $BUS $ADDR 0x13 $((1<<$i))
    sleep 0.1
done

for i in {6..-1..-1};
do
    i2cset -y $BUS $ADDR 0x13 $((1<<$i))
    sleep 0.1
done

i2cset -y $BUS $ADDR 0x13 0xff

# Read switches
i2cget -y $BUS $ADDR 0x12 b