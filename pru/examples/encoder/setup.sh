HEADER=P8_
PINS="15 16"

echo "-Configuring pinmux"
	for PIN_NUMBER in $PINS
	do
		config-pin -a $HEADER$PIN_NUMBER pruin
		config-pin -q $HEADER$PIN_NUMBER
	done
