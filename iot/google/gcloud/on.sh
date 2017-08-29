#!/bin/bash
# Enable billing
gcloud beta billing projects link trim-approach-136823 --billing-account=00E94B-863694-0FAA15

# Start the instances
# gcloud compute instances start instance-1 instance-2 instance-3 instance-4
gcloud compute instances start instance-1

