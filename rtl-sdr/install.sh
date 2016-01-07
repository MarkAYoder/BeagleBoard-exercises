# If you just want to listen to FM try:
# http://sdr.osmocom.org/trac/wiki/rtl-sdr
apt-get install rtl-sdr

# Then you can decode on the Bone and send the data to a host to play.
# On the bone
# rtl_fm -f 92.7M -M wbfm -r 48000 - | netcat -l -p8082
# On the host
# nc bone 8082 | aplay -r 48k -f S16_LE


# Here's how to track airplanes
# From: http://makezine.com/projects/tracking-planes-with-rtl-sdr/

apt-get install cmake
apt-get install libusb-1.0-0-dev
git clone git://git.osmocom.org/rtl-sdr.git
cd rtl-sdr
cmake ./ -DINSTALL_UDEV_RULES=ON
make
make install
cd ..
git clone https://github.com/MalcolmRobb/dump1090 MR-dump1090
cd MR-dump1090
make
./dump1090 --interactive --net --net-http-port 8081
