# This reads the current temp from a TMP101 sensor on i2c bus 1 at 0x49 and publishes it.

TMP101bus=1
TMP101addr=0x49

while true; do
    TEMP=`i2cget -y $TMP101bus $TMP101addr`
    mosquitto_pub -t 'temp' -m $TEMP
    sleep 10
done
