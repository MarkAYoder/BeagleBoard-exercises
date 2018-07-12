# From: https://medium.com/google-cloud/build-a-weather-station-using-google-cloud-iot-core-and-mongooseos-7a78b69822c5

git clone https://github.com/alvarowolfx/weather-station-gcp-mongoose-os

export PROJECT_ID=iot-core-may

# Authenticate with Google Cloud:
gcloud auth login
# Create cloud project — choose your unique project name:
gcloud projects create $PROJECT_ID
# Set current project
gcloud config set project $PROJECT_ID


# Add permissions for IoT Core
gcloud projects add-iam-policy-binding $PROJECT_ID --member=serviceAccount:cloud-iot@system.gserviceaccount.com --role=roles/pubsub.publisher
# Create PubSub topic for device data:
gcloud pubsub topics create telemetry-topic
# Create PubSub subscription for device data:
gcloud pubsub subscriptions create \
    --topic telemetry-topic telemetry-subscription
# Create device registry:
gcloud iot registries create weather-station-registry \
    --region us-central1 \
    --state-pubsub-topic=telemetry-topic

# Edit 
#     // const payload = `${argv.registryId}/${argv.deviceId}-payload-${messagesSent}`;
#    const payload = `{"hum":35, "temp":${messagesSent}}`;

# These are for the weather station example
node cloudiot_mqtt_example_nodejs.js \
    --projectId=$PROJECT_ID \
    --registryId=weather-station-registry \
    --deviceId=my-device \
    --privateKeyFile=rsa_private.pem \
    --numMessages=5 \
    --algorithm=RS256 \
    --messageType=state

gcloud pubsub subscriptions pull --auto-ack --limit 5 telemetry-subscription
