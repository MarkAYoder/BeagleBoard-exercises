# This reads the raw temp and multiples it by the scale.

# tmp=/sys/class/i2c-adapter/i2c-3/3-004d/iio:device1
tmp=/sys/class/i2c-adapter/i2c-5/5-0048/iio:device1

temp="`cat $tmp/in_temp_raw`*`cat $tmp/in_temp_scale`"
echo $temp
echo $temp | bc

cat $tmp/in_temp_input