#!/usr/bin/env python
# sudo apt-get install python-pip
# sudo pip install twilio
from twilio.rest import TwilioRestClient 
 
# put your own credentials here 
ACCOUNT_SID = "AC407ab27aab63fa995dbc24c43a18d204" 
AUTH_TOKEN = "99e44f31bc8c7981c4ae6d6cf9c65ed" 
 
client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN) 
 
client.messages.create(
	to="8122333219", 
	from_="+18122203095", 
	body="This is a test",  
)
