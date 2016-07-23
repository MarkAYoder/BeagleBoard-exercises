HEADER=P8_
PINS="27 28 29 39 40 41 42 43 44 45 46"

echo "-Configuring pinmux"
	for PIN_NUMBER in $PINS
	do
		config-pin -a $HEADER$PIN_NUMBER pruout
		config-pin -q $HEADER$PIN_NUMBER
	done
