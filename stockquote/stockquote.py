#!/usr/bin/env python
# From: http://www.instructables.com/id/Getting-Stock-Prices-on-Raspberry-Pi-Python/
import ystockquote

tickerSymbol = 'ADSK'
allInfo = ystockquote.get_all(tickerSymbol)
print tickerSymbol + " Price = " + allInfo["price"]
