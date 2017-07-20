# Connect to Wifi using connman
# From: https://wiki.archlinux.org/index.php/Connman#Wi-Fi
# Also try:
# scan wifi
# services
connmanctl << EOF
enable wifi
agent on
config wifi_*_managed_psk autoconnect on
connect wifi_f45eab3b76c7_596f646572576972656c65737332_managed_psk
quit
EOF
