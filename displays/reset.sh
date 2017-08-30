# Clears out gpio exports
for pin in 49 57 97 98 113 116;
do
    cd /sys/class/gpio
    echo $pin > unexport
done
