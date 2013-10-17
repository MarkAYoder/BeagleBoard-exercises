#!/bin/bash
# This git pulls all the student repo's
for dir in *
do
    if [ -d $dir ] && [ "${dir}" != "Old" ]
    then
	echo $dir
	cd $dir
	git pull
	cd ..
    fi
done
