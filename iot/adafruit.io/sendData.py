#!/usr/bin/env python
# From: https://adafruit-io-python-client.readthedocs.io/en/latest/data.html

# Import library and create instance of REST client.
from Adafruit_IO import Client, Data
import os

# Get environment variables
USER     = os.getenv('AIO_USER')
PASSWORD = os.getenv('AIO_KEY')

aio = Client(USER, PASSWORD)

# Get list of feeds.
feeds = aio.feeds()

# # Print out the feed names:
# for f in feeds:
#     print('Feed: ({0})'.format(f.name))

# Add the value 98.6 to the feed 'light'.  Needs to be lower-case
test = aio.feeds('light')
aio.send_data(test.key, 98.6)

# Create a data item with value 30 in the 'button' feed.
data = Data(value=30)
aio.create_data('button', data)