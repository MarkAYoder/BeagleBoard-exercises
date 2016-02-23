#!/bin/bash
# Usage"  sub.sh [feed]
feed=${1:-Light}
TOPIC=$AIO_USER/feeds/$feed

echo Subscribing to $TOPIC

mosquitto_sub -v -d \
    -u $AIO_USER \
    -P $AIO_KEY \
    -q 1 \
    -h io.adafruit.com \
    -p 1883 \
    -t "$TOPIC"
