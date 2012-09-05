#!/bin/bash
muxDir=/sys/kernel/debug/omap_mux
cd $muxDir
for file in * 
do
	echo -e "\e[00;31m$file\e[00m"
	cat $file
done
