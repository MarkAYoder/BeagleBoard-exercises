#!/usr/bin/env python
import opc
pattern = [ 0, 0, 255 ] * 8 * 8
client = opc.Client('localhost:7890')
client.put_pixels(pattern)
