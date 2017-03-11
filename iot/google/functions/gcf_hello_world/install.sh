# From: https://cloud.google.com/functions/docs/quickstart
git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples.git

export PROJECT=curious-kingdom-800
export BUCKET=play-123

gcloud beta functions deploy helloWorld --stage-bucket $BUCKET --trigger-topic hello_world
gcloud beta functions call   helloWorld --data '{"myMessage":"Hello World!"}'
gcloud beta functions logs read helloWorld

gcloud beta pubsub topics publish hello_world '{"myMessage":"Testing..."}'
