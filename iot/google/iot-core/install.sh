# From: https://cloud.google.com/iot/docs/quickstart

git clone https://github.com/GoogleCloudPlatform/nodejs-docs-samples

export PROJECT_ID=core-iot-may

gcloud pubsub subscriptions create \
    projects/$PROJECT_ID/subscriptions/my-subscription \
    --topic=projects/$PROJECT_ID/topics/my-device-events
    
node cloudiot_mqtt_example_nodejs.js \
    --projectId=$PROJECT_ID \
    --registryId=my-registry \
    --deviceId=my-device \
    --privateKeyFile=rsa_private.pem \
    --numMessages=5 \
    --algorithm=RS256

gcloud pubsub subscriptions pull --auto-ack \
    projects/$PROJECT_ID/subscriptions/my-subscription
    
gcloud pubsub subscriptions delete \
    projects/$PROJECT_ID/subscriptions/my-subscription
    