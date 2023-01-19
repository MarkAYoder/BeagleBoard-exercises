# From: https://hub.docker.com/r/webthingsio/gateway
sudo docker -D run \
    -e TZ=America/Indiana/Indianapolis \
    -v /home/debian/exercises/iot/webthings/data:/home/debian/.webthings \
    --network="host" \
    --log-opt max-size=1m \
    --log-opt max-file=10 \
    --name webthings-gateway \
    webthingsio/gateway:latest

#    -d \