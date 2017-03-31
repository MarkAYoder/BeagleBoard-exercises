# Start the instances then run the following to ge their IP addresses.

# Enable billing
gcloud alpha billing accounts projects link trim-approach-136823 --account-id=007BE9-25D7D3-F8BBDD

# Start the instances
gcloud config set compute/zone us-central1-b
gcloud compute instances start instance-1 instance-2 instance-3

echo Check /etc/hosts for extra entries
gcloud compute instances list | tail -3 | awk '{print $5 "\t" $1}' | tee /etc/hosts

# Open port 6379 for redis

gcloud compute firewall-rules list
gcloud compute firewall-rules create redis --allow=tcp:6379

# Stop the instances
# gcloud compute instances stop instance-1 instance-2 instance-3

# Turn off billing
gcloud alpha billing accounts projects unlink trim-approach-136823
