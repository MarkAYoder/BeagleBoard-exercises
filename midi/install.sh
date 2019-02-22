# This is all that's needed for the Beagle

sudo apt install midisport-firmware
pip3 install mido
pip3 install python-rtmidi

sudo apt-get install libasound2-dev

# These are more tools for the host

timidity -iA  # Listens on 4 ports
aplaymidi -p 128:0 bwv538t.mid	# Plays to one of those ports

sudo apt install kmidimon	# Monitors midi traffice

sudo apt install vkeybd

sudo apt install libcanberra-gtk-module

time sudo apt install vmpk

# For mftext
apt install abcmidi
