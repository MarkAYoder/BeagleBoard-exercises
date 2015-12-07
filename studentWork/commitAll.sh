#!/bin/bash
# Updates all student repos
for dir in *; do
    if [ -d "$dir" ]; then
        echo $dir
        cd "$dir"
	git commit -a -m "Added lab02 grade"
        cd ..
    fi
done
