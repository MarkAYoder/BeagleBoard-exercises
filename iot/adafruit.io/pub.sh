#!/bin/bash
# Usage"  pub.sh "Message" [feed]

feed=${2:-Light}
TOPIC=$AIO_USER/feeds/$feed

echo Publishing $1 to $TOPIC

mosquitto_pub -d \
    -u $AIO_USER \
    -P $AIO_KEY \
    -q 1 \
    -h io.adafruit.com \
    -p 1883 \
    -t "$TOPIC" \
    -m "$1"
