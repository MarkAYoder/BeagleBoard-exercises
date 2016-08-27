# This is for setting up Docker to compile a BeagleBone kernel.
# This is run on the host
# From: https://docs.docker.com/engine/tutorials/dockerimages/#/getting-a-new-image
# http://elinux.org/EBC_Exercise_08_Installing_Development_Tools_4.4#Getting_the_4.4_Kernel
# Install Docker: https://docs.docker.com/engine/installation/linux/ubuntulinux/
tmux    # in case the connection is lost
docker run -i -t ubuntu bash
# The following are run in the docker container
cd
apt-get update              # ?s, 6s
apt-get install git wget     # 2 min 38 sec 2 cores, 21s 22 cores
git clone https://github.com/RobertCNelson/bb-kernel.git        # 3m17, 7sec

apt-get install bc build-essential device-tree-compiler fakeroot lsb-release lzma lzop man-db # 6m13, 30 sec
apt-get install libncurses5-dev:amd64       #  7s, 3.7s

git config --global user.name "Mark A. Yoder"
git config --global user.email Mark.A.Yoder@Rose-Hulman.edu
git config --global push.default simple
git config --global color.ui true
git config --global credential.helper "cache --timeout=14400"

cd bb-kernel
git checkout am33x-v4.4
./build_kernel.sh   
exit        # Leave docker

# This takes awhile and uses lots of memory
docker ps -a
docker commit -m "Added bb-kernel to compile BeagleBone kernel" -a "Mark A. Yoder" aefc895da7c8 yoder/kernel:v1
docker login
docker push yoder/kernel        # 10 minutes on 22 core machine
docker run -t -i yoder/kernel:v1 bash

# On another machine
docker run -t -i yoder/kernel:v1 bash

# Copy to Google Container Repositiory
# https://cloud.google.com/container-registry/docs/pushing?hl=en_US&_ga=1.141652913.2073565126.1468412417
docker tag yoder/kernel:v1 gcr.io/trim-approach-136823/beagle-kernel
gcloud docker push gcr.io/trim-approach-136823/beagle-kernel
