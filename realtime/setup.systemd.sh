#!/bin/bash
# Move the service file to the right place and enable it
cp boneServer.service /lib/systemd/system
systemctl start boneServer
systemctl enable boneServer
