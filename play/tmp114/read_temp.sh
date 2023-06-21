# This reads the tmp114 raw temp and multiples it by the scale.

tmp114=/sys/class/i2c-adapter/i2c-3/3-004d/iio:device1

temp="`cat $tmp114/in_temp_raw`*`cat $tmp114/in_temp_scale`"
echo $temp
echo $temp | bc
