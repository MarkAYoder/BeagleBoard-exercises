TweetBlinky
===========

11-25-2013
SparkFun Electronics 2013
Shawn Hymel

License
-------

This code is public domain but you buy me a beer if you use this and we meet 
someday (Beerware license).

Description
-----------

This python script shows how to setup a Twitter streamer object to monitor
Twitter for any messages (Tweets) containing a specified keyword (hashtag in
this case).

Hardware
--------

You need the following:
 * Rasbperry Pi running the latest release of Raspbian
 * USB cable and wall charger to power the Raspberry Pi
 * Ethernet or WiFi for the Raspberry Pi
 * Breadboard
 * LED
 * 330 Ohm resistor
 * 2x Male-to-Female jumper wires
 
Connect a jumper wire from Pin 22 of the Pi's GPIO header to one side of the
resistor on the breadboard. Connect the anode (+) of the LED to the other side
of the resistor. Run a jumper wire from the cathode (-) of the LED to a GND
pin on the Raspberry Pi.

Required Packages
-----------------

You will need Twython for the Twitter Streamer. Install these packages on the
Raspberry Pi:

 $ sudo apt-get update
 $ sudo apt-get install python-pip
 $ sudo pip install twython

Twitter Registration
--------------------

Go to https://dev.twitter.com and sign in. Under your user icon, select "My
Applications" and create a new app. Create an access token. Copy down the
Consumer Key, Consumer Secret, Access Token, and Access Token Secret.

Configuration
-------------

Change the TERMS variable to whatever you want to search for (if you don't
want #LOL).

Paste the Twitter credentials in the Twitter Authentication section of the
code.

How to Run
----------

Use the following command to run inside of the Rasbperry Pi (note the 'sudo' -
superuser access is required to communicate with the GPIO pins)

 $ sudo python TweetBlinky.py
