#!/bin/bash
# Usage"  sub.sh [topic]
TOPIC=${1:-hello/world}

echo Subscribing to $TOPIC

mosquitto_sub -d -v \
    --cafile CA.pem \
    --cert cert.pem \
    --key privateKey.pem \
    --tls-version tlsv1.2 \
    -q 1 \
    -h A3L43PS2R481G5.iot.us-east-1.amazonaws.com \
    -p 8883 \
    -t "$TOPIC"
