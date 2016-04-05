# http://sonic-pi.net/

wget http://sonic-pi.net/files/releases/v2.9.0/Sonic-Pi-for-RPi-Jessie-v2.9.0.tgz
tar xvzf Sonic-Pi-for-RPi-Jessie-v2.9.0.tgz
apt-get install libqscintilla2-11
apt-get install libqtnetwork4-perl

./sonic-pi-v2.9.0/bin/sonic-pi 
