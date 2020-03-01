# This reads the current temp from a TMP101 sensor on i2c bus 1 at 0x49 and publishes it.

# TMP101 sensor
# TMP101bus=1
# TMP101addr=0x49
# Some other sensor
TMP101bus=0
TMP101addr=0x34

i=0

while true; do
    TEMP=`i2cget -y $TMP101bus $TMP101addr`
    mosquitto_pub -t 'temp' -m "`date`, $i: $TEMP"
    i=$[$i+1]
    sleep 15
done
