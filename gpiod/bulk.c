// From: https://github.com/starnight/libgpiod-example/blob/master/libgpiod-led/main.c
#include <gpiod.h>
#include <stdio.h>
#include <unistd.h>

#ifndef	CONSUMER
#define	CONSUMER	"Consumer"
#endif

int main(int argc, char **argv)
{
	char *chipname = "gpiochip1";
	unsigned int line_num[] = {18, 19};	// GPIO Pins P9_14 and P9_16
	unsigned int val;
	struct gpiod_chip *chip;
	struct gpiod_line_bulk line[2];
	int i, ret;

	chip = gpiod_chip_open_by_name(chipname);
	if (!chip) {
		perror("Open chip failed\n");
		goto end;
	}

	int err = gpiod_chip_get_lines(chip, line_num, 2, line);
	if (err) {
		perror("Get line failed\n");
		goto close_chip;
	}

	int off_values[] = {0, 0};
	int  on_values[] = {1, 1};
	ret = gpiod_line_request_bulk_output(line, CONSUMER, off_values);
	if (ret < 0) {
		perror("Request line as output failed\n");
		goto release_line;
	}

	/* Blink 20 times */
	val = 0;
	while(1) {
		if(val) {
			ret = gpiod_line_set_value_bulk(line, on_values);
			if (ret < 0) {
				perror("Set line output failed\n");
				goto release_line;
			}
		} else{
			ret = gpiod_line_set_value_bulk(line, off_values);
			if (ret < 0) {
				perror("Set line output failed\n");
				goto release_line;
			}
		}
		// printf("Output %u on line #%u\n", val, line_num);
		// sleep(1);
		val = !val;
	}

release_line:
	gpiod_line_release_bulk(line);
close_chip:
	gpiod_chip_close(chip);
end:
	return 0;
}
