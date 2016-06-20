# From: https://docs.docker.com/engine/installation/linux/debian/#debian-jessie-80-64-bit
# Also: https://groups.google.com/forum/#!category-topic/beagleboard/beaglebone-black/2cnwVEmKqX4

apt-get install docker.io

docker info
docker run armhf/hello-world
docker run -i -t armhf/debian bash
docker run -i -t armhf/ubuntu bash

# Here's where to find other armhf images: https://hub.docker.com/u/armhf/?page=1