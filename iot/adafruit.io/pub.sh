#!/bin/bash
# Usage"  pub.sh "Message" [topic]

TOPIC=${2:-$AIO_USER/feeds/Wunderground}

mosquitto_pub -d \
    -u $AIO_USER \
    -P $AIO_KEY \
    -q 1 \
    -h io.adafruit.com \
    -p 1883 \
    -t "$TOPIC" \
    -m "$1"
