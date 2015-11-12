# Listens for data

mosquitto_sub -d -t hello/world

# Publishes data

mosquitto_pub -d -t hello/world -m "Hello, MQTT. This is my first message."