# Turns off and on the LED triggers
LEDpath='/sys/class/leds/beaglebone:green:usr'
onTrigger=(heartbeat mmc0 cpu0 mmc1)

if [ $1 == "off" ]; then
    for led in {0..3}
    do
        echo none > ${LEDpath}${led}/trigger
    done
else
    for led in {0..3}
    do
        echo ${onTrigger[$led]} > ${LEDpath}$led/trigger
    done
fi
            
# if(process.argv[2] === 'off') {
#     fs.writeFileSync(path+'0/trigger', 'none');
#     fs.writeFileSync(path+'1/trigger', 'none');
#     fs.writeFileSync(path+'2/trigger', 'none');
#     fs.writeFileSync(path+'3/trigger', 'none');
# //    fs.writeFileSync('/sys/class/leds/wifi/brightness', '0');
# //    fs.writeFileSync('/sys/class/gpio/gpio49/value', '0');
# } else {
#     fs.writeFileSync(path+'0/trigger', 'heartbeat');
#     fs.writeFileSync(path+'1/trigger', 'mmc0');
#     fs.writeFileSync(path+'2/trigger', 'cpu0');
#     fs.writeFileSync(path+'3/trigger', 'mmc1');
# //    fs.writeFileSync('/sys/class/gpio/gpio49/value', '1');
# }
