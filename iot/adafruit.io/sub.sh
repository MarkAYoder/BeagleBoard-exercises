#!/bin/bash
# Usage"  sub.sh [topic]
TOPIC=${1:-markyoder/feeds/Wunderground}

echo Subscribing to $TOPIC

mosquitto_sub -v -d \
    -u markyoder \
    -P e3c496b806b35ce4b3c97dd3cb7cf8af0ca2d196 \
    -q 1 \
    -h io.adafruit.com \
    -p 1883 \
    -t "$TOPIC"
