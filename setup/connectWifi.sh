# Connect to Wifi using connman
# From: https://wiki.archlinux.org/index.php/Connman#Wi-Fi
connmanctl << EOF
enable wifi
agent on
connect wifi_f45eab3b76c7_596f646572576972656c65737332_managed_psk
quit
EOF
