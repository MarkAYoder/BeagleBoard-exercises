# From: https://azure.microsoft.com/en-us/documentation/samples/iot-hub-c-raspberrypi-getstartedkit/

git clone --recursive https://github.com/Azure/azure-iot-sdks.git
git clone https://github.com/Azure-Samples/iot-hub-c-raspberrypi-getstartedkit.git
cp -a iot-hub-c-raspberrypi-getstartedkit/azure-iot-sdks/. azure-iot-sdks/

# Note: BeagleWest-map (Microsoft.BingMaps/mapApis) failed when using US East, but
# worked for US West

# From: https://azure.microsoft.com/en-us/develop/iot/get-started/
npm install -g azure-iot-device