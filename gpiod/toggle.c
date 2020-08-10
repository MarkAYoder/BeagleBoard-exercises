// From: https://developer.toradex.com/knowledge-base/libgpiod
// gcc -gpiod toggle.c -o toggle
#include <gpiod.h>

void main() {
//Define GPIO chip and line structs:
	struct gpiod_chip *output_chip;
	struct gpiod_line *output_line;

// Configure a GPIO as output:
	/* open the GPIO bank */
	int bank = 1;
	output_chip = gpiod_chip_open_by_number(bank);
 
	/* open the GPIO line */
	int line = 18;
	output_line = gpiod_chip_get_line(output_chip, line);
 
	/* config as output and set a description */
	gpiod_line_request_output(output_line, "gpio-test",
		GPIOD_LINE_ACTIVE_STATE_HIGH);

// Toggle a GPIO:
	while(1) {
	    /* Clear */
	    int line_value = 0;
	    gpiod_line_set_value(output_line, line_value);
	 
	    /* Set */
	    line_value = 1;
	    gpiod_line_set_value(output_line, line_value);
	}
}
