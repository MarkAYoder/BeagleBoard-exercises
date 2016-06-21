# This never worked.
# From: https://wiki.debian.org/BluetoothUser#Pairing
# and http://unix.stackexchange.com/questions/258074/error-when-trying-to-connect-to-bluetooth-speaker-org-bluez-error-failed

apt-get install pulseaudio-module-bluetooth
pulseaudio -k       # Stop server
pulseaudio --start  # Start server

# bluetoothctl

Start the bluetoothctl interactive command. Enter "help" to get a list of available commands.

Turn the power to the controller on by entering "power on". It is off by default.
Enter "devices" to get the MAC Address of the device with which to pair.
Enter device discovery mode with "scan on" command if device is not yet on the list.
Turn the agent on with "agent on".
Enter "pair MAC Address" to do the pairing (tab completion works).
If using a device without a PIN, one may need to manually trust the device before it can reconnect successfully. Enter "trust MAC Address" to do so.
Finally, use "connect MAC address" to establish a connection.

cat > /etc/bluetooth/audio.conf << EOF
# Configuration file for the audio service
[General]
Enable=Source,Sink,Media,Socket
EOF
