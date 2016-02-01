#!/bin/bash
# Usage"  sub.sh [topic]
TOPIC=${1:-$AIO_USER/feeds/Wunderground}

echo Subscribing to $TOPIC

mosquitto_sub -v -d \
    -u $AIO_USER \
    -P $AIO_KEY \
    -q 1 \
    -h io.adafruit.com \
    -p 1883 \
    -t "$TOPIC"
