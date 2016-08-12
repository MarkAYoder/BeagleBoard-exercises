# This works on the host.  apt-get install doesn't find it for the Bone.
# Start here: https://cloud.google.com/storage/docs/gcs-fuse
# Install gcsfuse: https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/installing.md

export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
# You might get an error message, but it appears to work.
sudo apt-get update
sudo apt-get install gcsfuse

# Go here to set up service account: https://cloud.google.com/storage/docs/authentication#service_accounts
# Go here and select your project: https://console.cloud.google.com/apis/credentials
#   Click "Create Credentials" and select "service account key"
#       Select "New service account" and give it a name
#       For "Role" select Storage:Storage Admin
#       Keep JSON select and click "Create"
# Copy the downloaded file to your directory
export GOOGLE_APPLICATION_CREDENTIALS=<absolute path to .json file>
mkdir gcs
gcsfuse bucket-yoder gcs # Here bucket-yoder is the name of your bucket
