# Start the instances then run the following to ge their IP addresses.
echo Check /etc/hosts for extra entries
gcloud compute instances list | tail -3 | awk '{print $5 "\t" $1}' | tee /etc/hosts

# Open port 6379 for redis

gcloud compute firewall-rules list
