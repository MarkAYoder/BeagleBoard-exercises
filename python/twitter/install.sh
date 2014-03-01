#!/bin/bash

apt-get update
apt-get install python-pip
apt-get install python-dev
easy_install -U distribute
pip install twython
pip install Adafruit_BBIO

wget https://dlnmh9ip6v2uc.cloudfront.net/assets/e/f/7/d/6/5293c025ce395f30678b4567.zip
unzip 5293c025ce395f30678b4567.zip
