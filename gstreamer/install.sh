# Pull Jessie version of GStreamer
echo "deb ftp://ftp.debian.org/debian/ jessie main 
deb-src ftp://ftp.debian.org/debian/ jessie main" > /etc/apt/sources.list.d/jessie.list
apt-get update 

# These take 30 minutes
apt-get install libgstreamer1.0-0 
apt-get install gstreamer2.0-alsa gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad 

cd ../autogain
gcc autogain.c -o autogain
