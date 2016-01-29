#!/bin/bash
mosquitto_pub --cafile CA.pem \
    --cert cert.pem \
    --key privateKey.pem \
    -h A3L43PS2R481G5.iot.us-east-1.amazonaws.com \
    -d -t hello/world \
    -m "Test 1"
