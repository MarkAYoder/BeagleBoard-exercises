#!/bin/bash
# From page 224 of Embedded Linux Primer
# Be sure to source ~/crossCompileEnv.sh
make -C ~/BeagleBoard/linux-dev/KERNEL SUBDIRS=$PWD modules
