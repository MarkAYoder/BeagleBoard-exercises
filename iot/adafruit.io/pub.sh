#!/bin/bash
# Usage"  pub.sh "Message" [topic]
TOPIC=${2:-markyoder/feeds/Wunderground}

mosquitto_pub -d \
    -u markyoder \
    -P e3c496b806b35ce4b3c97dd3cb7cf8af0ca2d196 \
    -h io.adafruit.com \
    -p 1883 \
    -t "$TOPIC" \
    -m "$1"
