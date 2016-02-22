#!/bin/bash
# This removes some unneeded files to make some room
apt-get autoremove opencv*      # 311MB
rm -r /usr/lib/chromium-browser/
rm -r /usr/bin/chromium-browser
rm -r /usr/share/doc
rm -r /usr/share/man