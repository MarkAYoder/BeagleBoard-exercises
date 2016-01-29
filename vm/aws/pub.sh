#!/bin/bash
mosquitto_pub -d \
    --cafile CA.pem \
    --cert cert.pem \
    --key privateKey.pem \
    --tls-version tlsv1.2 \
    -h A3L43PS2R481G5.iot.us-east-1.amazonaws.com \
    -p 8883 \
    -t hello/world \
    -m "Test 1"
