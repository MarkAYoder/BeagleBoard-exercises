#!/bin/bash
# Updates all student repos
for dir in *; do
    if [ -d "$dir" ]; then
        echo $dir
        cd "$dir"
        git push
        cd ..
    fi
done
