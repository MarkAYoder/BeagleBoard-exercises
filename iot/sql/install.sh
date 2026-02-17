pip install paho-mqtt

sudo apt install mosquitto

# Defaults to only listening on localhost
# To listen on all interfaces, edit /etc/mosquitto/mosquitto.conf/home-assistant.conf
# listen 0.0.0.0
# allow_anonymous true
# Then restart mosquitto: sudo systemctl restart mosquitto