# Start the instances then run the following to ge their IP addresses.

# Enable billing
gcloud beta billing projects link trim-approach-136823 --billing-account=00E94B-863694-0FAA15

# Start the instances
gcloud config set compute/zone us-central1-b
gcloud compute instances start instance-1 instance-2 instance-3 instance-4

echo Check /etc/hosts for extra entries
gcloud compute instances list | tail --lines=+2 | awk '{print $5 "\t" $1}'

# Open port 6379 for redis

gcloud compute firewall-rules list
gcloud compute firewall-rules create redis --allow=tcp:6379
gcloud compute firewall-rules create mongo --allow=tcp:27017
gcloud compute firewall-rules create neo4j --allow=tcp:7474
gcloud compute firewall-rules create solr  --allow=tcp:8983

# Stop the instances
# gcloud compute instances stop instance-1 instance-2 instance-3 instance-4

# Turn off billing
gcloud alpha billing accounts projects unlink trim-approach-136823

# Add to ~/.ssh/config
Host instance-4
   User mark_a_yoder
   UserKnownHostsFile /dev/null
   StrictHostKeyChecking no

# Setting up metadata sshKeys
gcloud compute project-info add-metadata --metadata-from-file sshKeys=~/.ssh/id_rsa.pub
gcloud compute ssh instance-4

