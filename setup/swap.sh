# From: http://prashank.xyz/2016/01/24/npm_install_gets_killed/
# Untested

fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab