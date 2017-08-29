#!/bin/bash
# Stop the instances
# gcloud compute instances stop instance-1 instance-2 instance-3 instance-4
gcloud compute instances stop instance-16

# Turn off billing
gcloud beta billing projects unlink trim-approach-136823

