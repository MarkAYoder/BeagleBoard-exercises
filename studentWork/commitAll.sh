#!/bin/bash
# Updates all student repos
for dir in *; do
    if [ -d "$dir" ]; then
        echo -e "\e[31m$dir\e[00m"
        cd "$dir"
	git commit -a -m "Added lab02 grade"
        cd ..
    fi
done
