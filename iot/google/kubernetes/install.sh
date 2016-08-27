# Following insturctions here:

export PROJECT_ID=my-kubernetes-codelab-141614

# This was needed to connect to the Docker demon
# From: http://stackoverflow.com/questions/21871479/docker-cant-connect-to-docker-daemon
sudo usermod -aG docker $(whoami)
