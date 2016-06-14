#!/bin/bash

# Assumes cookbook and bone101 are in ~
# This was a nice idea, but asciidoc doesn't define <screen> and
# doesn't know how to pull in .js file with include.

source=~/beaglebone-cookbook
target=~/bone101/examples/cookbook

mkdir -p $target

path=BeagleBoard/beaglebone-cookbook
file=02-sensors
echo /tmp/$file.asciidoc

./extract.js $source/ch02_sensors.asciidoc /tmp/$file.asciidoc
scp /tmp/$file.asciidoc yoder@host:$path
ssh yoder@host "cd $path && asciidoc $file.asciidoc"
scp yoder@host:$path/$file.html $target
