#!/bin/bash
tmpDir=/tmp
mkdir $tmpDir/printers
cd $tmpDir/printers
wget http://lug.rose-hulman.edu/mw/images/c/cf/Rose_cups.tar.bz2
tar -xvf Rose_cups.tar.bz2
cd cups
sudo cp /etc/cups/printers.conf /etc/cups/printers.conf.v0
sudo cp ./printers.conf /etc/cups/
sudo cp ./ppd/* /etc/cups/ppd
sudo /etc/init.d/cups restart
