ms = 500    # Read time in ms
pin = '7' #  P9_42 is gpio 7
GPIOPATH="/sys/class/gpio"

# Make sure pin is exported
if (not os.path.exists(GPIOPATH+"/gpio"+pin)):
    f = open(GPIOPATH+"/export", "w")
    f.write(pin)
    f.close()

# Make it an input pin
f = open(GPIOPATH+"/gpio"+pin+"/direction", "w")
f.write("in")
f.close()

f = open(GPIOPATH+"/gpio"+pin+"/value", "r")

while True:
    f.seek(0)
    data = f.read()[:-1]
    print("data = " + data)
    time.sleep(ms/1000)
