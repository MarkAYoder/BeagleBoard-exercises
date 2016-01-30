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
    --principal "arn:aws:iot:us-east-1:387934991171:cert/3edec1dca04cdddc6557da473848404e449f704598221df9df5fa302649e02c5" \
    --policy-name "PubSubToAnyTopic"
aws iot attach-thing-principal --thing-name "myLightBulb" \
    --principal "arn:aws:iot:us-east-1:387934991171:cert/3edec1dca04cdddc6557da473848404e449f704598221df9df5fa302649e02c5"

# Get
wget https://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem
mv VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem CA.pem

# Need version 1.4.7, so install a newer mosquitto
apt-get install mosquitto-clients/stretch

# This tells you the host address to use
aws iot describe-endpoint

# This tests the connection, but I'm not sure what it should return.
openssl s_client -connect iot.us-east-1.amazonaws.com:443 -CAfile CA.pem -cert cert.pem -key privateKey.pem

(
    # This might be a better starting point, but you need python3
    # http://blog.getflint.io/get-started-with-aws-iot-and-raspberry-pi
    wget https://gist.githubusercontent.com/shweta-nerake1/8684968ebacb5522c86a/raw/8d1e2dbcd523b5915f92603aee3f5794a5a13ead/iot-mqtt-subscriber.py
)

# Create a pole policy file
{
"Version": "2012-10-17",  
"Statement": [{
      "Sid": "",     
      "Effect": "Allow",      
      "Principal": { 
            "Service": "iot.amazonaws.com"
       },
      "Action": "sts:AssumeRole"
  }]
}

aws iam create-role --role-name iot-actions-role --assume-role-policy-document file://role.policy > role.json

aws iam create-policy --policy-name iot-actions-policy --policy-document file://iam.policy
aws iam attach-role-policy --role-name iot-actions-role --policy-arn "arn:aws:iam::387934991171:policy/iot-actions-policy"

aws iot create-topic-rule --rule-name saveToDynamoDB --topic-rule-payload file://saveDynamoDB.json

# Test with
./pub.sh '{"msg": "Hello, World 14"}' topic/test

# Try lambda function
aws iot create-topic-rule --rule-name invokeLambda --topic-rule-payload file://myHelloWorld.lambda

aws lambda add-permission --function-name "myHelloWorld" --region "us-east-1" \
    --principal iot.amazonaws.com \
    --source-arn arn:aws:iot:us-east-1:387934991171:rule/"myHelloWorld" \
    --source-account "387934991171" \
    --statement-id "unique_id" \
    --action "lambda:InvokeFunction"
    
aws lambda add-permission --function-name "myHelloWorld" \
    --principal iot.amazonaws.com \
    --statement-id "unique_id2" \
    --action "lambda:InvokeFunction"
    
# Test with
./pub.sh '{"key1": "Hello, World 21", "key2": "Test me"}' topic/test

    arn:aws:lambda:us-east-1:387934991171:function:myHelloWorld