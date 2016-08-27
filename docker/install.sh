# From: https://docs.docker.com/engine/installation/linux/debian/#debian-jessie-80-64-bit
# Also: https://groups.google.com/forum/#!category-topic/beagleboard/beaglebone-black/2cnwVEmKqX4

# Get the stretch version
echo "deb http://ftp.us.debian.org/debian/ stretch main contrib non-free" > /etc/apt/sources.list.d/stretch.list
apt-get update
apt-get install docker.io/stretch

docker info
docker run armhf/hello-world
docker run -i -t armhf/debian bash
docker run -i -t armhf/ubuntu bash

# Here's where to find other armhf images: https://hub.docker.com/u/armhf/?page=1

# Here's for building webapp for armhf
https://github.com/docker-training/webapp.git
cp Dockerfile.webapp webapp/Dockerfile
cd webapp
time docker build -t yoder/armhf-webapp:v2 .
# It took 48 minutes to build
docker run -d -P yoder/armhf-webapp python app.py
docker ps -l
# Point browser to bone:32768
docker stop goofy_payne

cd ..
cd whalesay

wget https://raw.githubusercontent.com/moxiegirl/whalesay/master/docker.cow
time docker build -t yoder/armhf-whalesay:v2 .

docker run yoder/armhf-whalesay:v2 cowsay Hello

docker push yoder/armhf-whalesay:v2

# On the host
sudo usermod -aG docker $(whoami)  # Reloggin
