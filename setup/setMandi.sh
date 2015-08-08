#!/bin/bash
# Copy remote's Mandi server date to local 
REMOTE=14.139.34.32

DATE=`ssh yoder@$REMOTE date`
date -s "$DATE"
