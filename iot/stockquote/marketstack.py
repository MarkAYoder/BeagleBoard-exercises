#!/usr/bin/env python
# From: https://marketstack.com/documentation
import requests
import os

params = {
  'access_key': os.getenv('ACCESS_KEY')
}

api_result = requests.get('http://api.marketstack.com/v1/tickers/aapl/eod', params)

api_response = api_result.json()

print(u'Ticker %s has a day high of  %s on %s' % (
    api_response['data']['symbol'], 
    api_response['data']['eod'][0]['high'], 
    api_response['data']['eod'][0]['date']
))