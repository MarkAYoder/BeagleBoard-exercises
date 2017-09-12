#!/bin/bash
# This git pulls all the student repo's
for dir in *
do
    if [ -d $dir ] && [ "${dir}" != "Old" ]
    then
	echo -e "\e[31m$dir\e[00m"
	cd $dir
	git pull
	cd ..
    fi
done
