# From: https://cloud.google.com/sdk/docs/

SDKz=google-cloud-sdk-150.0.0-linux-x86.tar.gz
SDK=google-cloud-sdk
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$SDKz
tar xzf $SDKz
cd $SDK
./install.sh
gcloud components install alpha
gcloud init
