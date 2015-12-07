#!/bin/bash
# Updates all student repos
for dir in *; do
    if [ -d $dir ]; then
        echo $dir
        cat $dir/id.txt
    fi
done
