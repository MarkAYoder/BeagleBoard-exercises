#!/bin/bash
mosquitto_sub -d -v \
    --cafile CA.pem \
    --cert cert.pem \
    --key privateKey.pem \
    -h A3L43PS2R481G5.iot.us-east-1.amazonaws.com \
    -p 8883 \
    -t hello/world
