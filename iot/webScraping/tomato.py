#!/usr/bin/env python
# From: http://paulusschoutsen.nl/blog/2013/10/tomato-api-documentation/
import re
import json
 
import requests
 
def get_tomato_info(host, username, password, http_id):
    req = requests.post('http://{}/update.cgi'.format(host),
                        data={'_http_id':http_id, 'exec':'devlist'},
                        auth=requests.auth.HTTPBasicAuth(username, password))
 
    tomato = {param: json.loads(value.replace("\'",'\"'))
             for param, value in re.findall(r"(?P<param>\w*) = (?P<value>.*);", req.text)
             if param != "dhcpd_static"}
 
    req = requests.get('http://{}/wireless.jsx?_http_id={}'.format(host, http_id),
                        auth=requests.auth.HTTPBasicAuth(username, password))
 
    tomato.update({param: json.loads(value.replace("'",'"'))
                    for param, value in re.findall(r"(?P<param>\w*) = (?P<value>.*);", req.text)
                    if param != 'u'})
 
    return tomato
 
print get_tomato_info("10.0.4.1", "root", password, "TIDba0438d0baf17347")
