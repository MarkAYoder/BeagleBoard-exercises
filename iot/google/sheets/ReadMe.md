Sheets IOT
==========
Be sure to run pip install -r requirements.txt as shown in install.sh
to have the correct versions installed.

Source setup.sh before running to install the i2c temperature sensors.

If token.pickle is missing, run on host to create and then 
copy back.


| Code | Function |
| ---- | -------- |
| demo.py | Give two arguments to be saved in the spreadsheet. |
| flashUp.py | Turns on green LED when network is up, Turns on ren when down.  Shows yellow when return time is 10% long that average of previous 10. |
| recordPing.py | Stores ping time in spreadsheet.         |
| temp.py       | Stores temp and humidity in spreadsheet. |
| tempio.py     | Stores indoor and outdoor temps.         |
