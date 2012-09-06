#!/bin/bash
cd ~/Downloads
sudo mkdir printers
cd printers
wget http://lug.rose-hulman.edu/mw/images/c/cf/Rose_cups.tar.bz2
tar -xvf Rose_cups.tar.bz2
cd cups
sudo cp ./printers.conf /etc/cups/
sudo cp ./ppd/* /etc/cups/ppd
cd ~/Downloads/
sudo rm -rf ./printers
sudo /etc/init.d/cups restart
clear

