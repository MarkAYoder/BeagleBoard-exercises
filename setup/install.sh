#!/usr/bash
# Here are the extra things I install on the bone
# --Mark
# 6-Jul-2012
cd ~
echo yoder-bone > /etc/hostname
opkg update
opkg install openssh-keygen
git clone git@github.com:MarkAYoder/BeagleBoard-exercises.git exercises
cp exercises/.bashrc .
ln -s /var/lib/cloud9 .
cd exercises/pinMux
ln -s $PWD/pinMux.html /var/lib/cloud9/bone101
cd cloud9
git pull
cd
opkg install alsa-dev
cd /usr/lib
ln -s libasound.so.2.0.0 libasound.so  # I don't know why this link is mising

opkg install i2c-tools-dev

# Here are some things I've had to do in the past, but don't now
# opkg install gcc gcc-symlinks libgcc-s-dev -force-overwrite
# This may do the gcc install too.
# beagle$ opkg install task-sdk-target (took about 8 minutes)
# Also did
# beagle$ opkg install evtest
# Here's what's needed to run the Flot demo
# beagle$ opkg install nodejs          (took about 1 minute)
# beagle$ opkg install alsa-utils      (took about 1 minute)
