# Here's how to get started with the Google Cloud Services
# https://cloud.google.com/compute/docs/quickstart
# I'm using Linux
# https://cloud.google.com/free-trial/

# SDK
# https://cloud.google.com/sdk/
# https://cloud.google.com/compute/docs/gcloud-compute
curl https://sdk.cloud.google.com | bash
source ~/.bashrc                # puts gcloud in PATH
gcloud init --console-only      # to authenticate, set up a default configuration, and clone the project's Git repository.

# Look at the dashboard to find the IP address
# https://console.cloud.google.com/compute/instances?project=curious-kingdom-800&graph=GCE_CPU&duration=PT1H

# On the Bone
cd ~/.ssh
cat id_rsa.pub
# copy the contents to the VM

# On the dashboard, click SHH (to the right of the IP address).
# A browser window will open with a terminal to the VM. Enter
cd ~/.ssh
cat >> authorized_keys
# Thenn paste the output from cat id_rsa.pub from the bone.

# Bach on the Bone
ssh mark_a_yoder@104.196.22.62
# Now you are connected to the VM

# Or, on the Bone, this will set up the authorized_keys for you.
gcloud compute ssh compile-kernel
# Then you can use
ssh -i ~/.ssh/google_compute_engine root@104.196.22.62

# Configure ssh.  On Bone
gcloud compute config-ssh

gcloud compute instances stop compile-kernel
gcloud compute instances start compile-kernel
