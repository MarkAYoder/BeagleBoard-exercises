# Make wheezy-backports and jessie available
# https://packages.debian.org/wheezy-backports/git
# https://packages.debian.org/jessie/git
echo "deb ftp://ftp.debian.org/debian/ wheezy-backports main
deb-src ftp://ftp.debian.org/debian/ wheezy-backports main" > /etc/apt/sources.list.d/wheezy-backports.list

echo "deb ftp://ftp.debian.org/debian/ jessie main
deb-src ftp://ftp.debian.org/debian/ jessie main" > /etc/apt/sources.list.d/jessie.list

apt-get update
