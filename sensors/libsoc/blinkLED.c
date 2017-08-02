#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

#include <libsoc_gpio.h>
#include <libsoc_debug.h>

// Blinks an LED attached to P9_14 (gpio1_18, 32+18=50)
#define GPIO_OUTPUT  49

int main(void) {
  gpio *gpio_output;    // Create gpio pointer
  libsoc_set_debug(1);  // Enable debug output
  // Request gpio
  gpio_output = libsoc_gpio_request(GPIO_OUTPUT, LS_SHARED);
  // Set direction to OUTPUT
  libsoc_gpio_set_direction(gpio_output, OUTPUT);

  libsoc_set_debug(0);   // Turn off debug printing for fast toggle

  int i;
  for (i=0; i<100; i++) {     // Toggle the GPIO 100 times
    libsoc_gpio_set_level(gpio_output, HIGH);
    usleep(100000);           // sleep 100,000 uS
    libsoc_gpio_set_level(gpio_output, LOW);
    usleep(100000);
  }

  if (gpio_output) {
    libsoc_gpio_free(gpio_output);  // Free gpio request memory
  }

  return EXIT_SUCCESS;
}
