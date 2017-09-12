#!/bin/bash
# Updates all student repos
for dir in *; do
    if [ -d $dir ]; then
        echo -e "\e[31m$dir\e[00m"
        cat $dir/id.txt
    fi
done
