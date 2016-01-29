npm install -g aws-sdk

# Or

pip install awscli

# Go to https://console.aws.amazon.com/iam/home?region=us-east-1#security_credential
# and create a new key pair, or find rootkey.csv and then run:
aws configure

# Then follow: https://docs.aws.amazon.com/iot/latest/developerguide/create-thing.html
aws iot create-thing --thing-name "myLightBulb"
# The steps are a bit unclear, so here's what I did:
aws iot create-keys-and-certificate --set-as-active --certificate-pem-outfile cert.pem \
    --public-key-outfile publicKey.pem --private-key-outfile privateKey.pem > cert.json
# Put the following in policy.json
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Action": ["iot:*"],
        "Resource": ["*"]
    }]
}
# Then run:
aws iot create-policy --policy-name "PubSubToAnyTopic" --policy-document file://policy.json 
# Note the "certificateArn": string in cert.json that was created above
# Paste it in for the --principal below
aws iot attach-principal-policy \
    --principal "arn:aws:iot:us-east-1:387934991171:cert/c8ac35fedaafca8a74a27e555fda30ebb5f0b18b21d64a331a922c8b8b7d40fe" \
    --policy-name "PubSubToAnyTopic"
aws iot attach-thing-principal --thing-name "myLightBulb" \
    --principal "arn:aws:iot:us-east-1:387934991171:cert/c8ac35fedaafca8a74a27e555fda30ebb5f0b18b21d64a331a922c8b8b7d40fe"

apt-get install mosquitto-clients

# This tells you the host address to use
aws iot describe-endpoint

# This tests the connection, but I'm not sure what it should return.
openssl s_client -connect iot.us-east-1.amazonaws.com:443 -CAfile CA.pem -cert cert.pem -key privateKey.pem

# This might be a better starting point
# http://blog.getflint.io/get-started-with-aws-iot-and-raspberry-pi
https://gist.githubusercontent.com/shweta-nerake1/8684968ebacb5522c86a/raw/8d1e2dbcd523b5915f92603aee3f5794a5a13ead/iot-mqtt-subscriber.py
