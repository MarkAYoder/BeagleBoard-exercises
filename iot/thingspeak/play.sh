# Playing with ThingSpeak
export CHANNEL=518308
export WRITEKEY=WOGHQ8UL1EC7RZIA
# wget http://api.thingspeak.com/channels/$CHANNEL/feed/last.json

curl "https://api.thingspeak.com/update.json?api_key=$WRITEKEY&field1=123"