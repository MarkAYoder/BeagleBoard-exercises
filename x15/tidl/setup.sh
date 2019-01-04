# Here's how to run some of the examples.
# From the host computer
ssh -XC root@x15

cd classification
# stream_config_inceptionnet.txt seems to have file missing
# stream_config_j11_v2.txt runs but gets the error 
#   "Corrupt JPEG data: 2 extraneous bytes before marker 0xd4"
#   So I send stderr to /dev/null
# stream_config_mobilenet.txt runs but it looks like the color channels are switched
./tidl_classification -g 1 -d 2 -e 2 -l ./imagenet.txt -s ./classlist.txt -i 0 -c ./stream_config_j11_v2.txt 2> /dev/null

# This will play a video and classify it.  Note:  The readme.md referenced test50.mp4,
#   but I'm using test10.mp4
./tidl_classification -g 1 -d 2 -e 2 -l ./imagenet.txt -s ./classlist.txt -i ./clips/test10.mp4 -c ./stream_config_j11_v2.txt


cd imagenet
sudo ./imagenet -d 2 -e2 -i IMG_3806.jpg
./imagenet -i camera0

