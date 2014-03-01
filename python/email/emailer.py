#!/usr/bin/env python
# From Getting Started with BeagleBone, Matt Richardson, p89
import smtplib
import getpass
from email.mime.text import MIMEText

def alertMe(subject, body):
    myAddress = "Mark.A.Yoder@gmail.com"
    password = getpass.getpass("%s's password: " % myAddress)
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = myAddress
    msg['Reply-to'] = myAddress
    msg['To'] = myAddress
    
    server = smtplib.SMTP('smtp.gmail.com', 587)
    # server.set_debuglevel(True)
    server.starttls()
    server.login(myAddress, password);
    server.sendmail(myAddress, myAddress, msg.as_string())
    server.quit()
    
alertMe("This is a test 3!", "Just testing...\n\n--Mark")