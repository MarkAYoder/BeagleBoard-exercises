# Pull Jessie version of GStreamer
echo "deb ftp://ftp.debian.org/debian/ jessie main 
deb-src ftp://ftp.debian.org/debian/ jessie main" > /etc/apt/sources.list.d/jessie.list
apt-get update 

# These take 30 minutes
apt-get install libgstreamer1.0-0 
apt-get install gstreamer1.0-alsa gstreamer1.0-tools gstreamer1.0-plugins-base 
apt-get install gstreamer1.0-plugins-good gstreamer1.0-plugins-bad  
apt-get install gstreamer1.0-plugins-ugly

cd ../autogain
gcc autogain.c -o autogain
