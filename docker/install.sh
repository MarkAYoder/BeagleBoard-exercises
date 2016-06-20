# From: https://docs.docker.com/engine/installation/linux/debian/#debian-jessie-80-64-bit
# Also: https://groups.google.com/forum/#!category-topic/beagleboard/beaglebone-black/2cnwVEmKqX4

docker info
docker run armhf/hello-world
docker run -i -t armhf/debian bash
docker run -i -t armhf/ubuntu bash