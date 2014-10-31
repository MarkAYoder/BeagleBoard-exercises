# This sets up apt-get to access Wheezy-backports and Jessie packages.
echo "deb ftp://ftp.debian.org/debian/ wheezy-backports main
deb-src ftp://ftp.debian.org/debian/ wheezy-backports main" > /etc/apt/sources.list.d/wheezy-backports.list
echo "deb ftp://ftp.debian.org/debian/ jessie main
deb-src ftp://ftp.debian.org/debian/ jessie main" > /etc/apt/sources.list.d/jessie.list
apt-get update
