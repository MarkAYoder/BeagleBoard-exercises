These are examples of using the PRUs as simple hardware devices

### encoder
Simple quadrature encoder

### pwm
18 channel PWM.  6 channels are on PRU0 and 12 are on PRU1.  Runs completly on
the PRUs.

### servo
Like the PRM, but the ARM is used to say when the pulse starts and the PRU times
the pulse. Period is not stable, but the pulse width is.
