#!/usr/bin/env python
# From: https://adafruit-io-python-client.readthedocs.io/en/latest/data.html

# Import library and create instance of REST client.
from Adafruit_IO import Client
import os

# Get environment variables
USER     = os.getenv('AIO_USER')
PASSWORD = os.getenv('AIO_KEY')

aio = Client(USER, PASSWORD)

# Get list of feeds.
feeds = aio.feeds()

# Print out the feed names:
for f in feeds:
    print('Feed: ({0})'.format(f.name))

# Get feed 'Foo'
feed = aio.feeds(feeds(2).name)

# Print out the feed metadata.
print(feed)

# Add the value 98.6 to the feed 'Temperature'.
test = aio.feeds('/Light')
aio.send_data(test.key, 98.6)
