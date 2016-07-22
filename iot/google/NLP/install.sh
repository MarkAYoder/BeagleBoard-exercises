# From: https://cloud.google.com/sdk/docs/#deb
# Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"

# Add the Cloud SDK distribution URI as a package source
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Update and install the Cloud SDK
sudo apt-get update && sudo apt-get install google-cloud-sdk

# Run gcloud init to get started
gcloud init

# To use ffmgeg
echo "deb http://ftp.us.debian.org/debian/ jessie-backports main contrib non-free" > /etc/apt/sources.list.d/jessie-backports
apt-get update
atp-get install ffmpeg
ffmpeg -i test.m4a -f s16le -acodec pcm_s16le test.raw
# Convert to flac, 1 channel, 16000 samples/sec
# From: http://stefaanlippens.net/audio_conversion_cheat_sheet
ffmpeg -i test.m4a -f flac -ac 1 -ar 16000 test.flac

# Or using sox
apt-get install sox
sox test.wav --rate 16k --bits 16 --channels 1 test2.flac trim 00:01 00:05

wget http://storage.googleapis.com/cloud-samples-tests/speech/brooklyn.flac
