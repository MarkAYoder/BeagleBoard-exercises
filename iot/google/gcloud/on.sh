#!/bin/bash
# Enable billing
gcloud alpha billing accounts projects link trim-approach-136823 --account-id=007BE9-25D7D3-F8BBDD

# Start the instances
gcloud compute instances start instance-1 instance-2 instance-3 instance-4

