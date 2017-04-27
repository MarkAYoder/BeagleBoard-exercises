# From: https://cloud.google.com/sdk/docs/

SDKz=google-cloud-sdk-153.0.0-linux-x86.tar.gz
SDK=google-cloud-sdk
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/$SDKz
tar xzf $SDKz
cd $SDK
./install.sh
gcloud components install alpha
gcloud init

# From: https://cloud.google.com/natural-language/docs/reference/libraries#client-libraries-resources-nodejs

sudo npm install --save @google-cloud/language
gcloud auth application-default login

wget https://raw.githubusercontent.com/GoogleCloudPlatform/nodejs-docs-samples/master/language/quickstart.js
# Edit const projectId =
