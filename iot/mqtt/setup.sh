# Listens for data

mosquitto_sub -d -t hello/world

# Publishes data

mosquitto_pub -d -t hello/world -m "Hello, MQTT. This is my first message."

# This is for reading the tmp101 sensor on i2c bus 1
config-pin P9_24 i2c
config-pin P9_26 i2c
