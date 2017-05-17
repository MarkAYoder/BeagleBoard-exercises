#include <rc_usefulincludes.h>
#include <roboticscape.h>

// pause button pressed interrupt function
int on_pause_pressed(){
	rc_set_led(GREEN, ON);
	printf("Pause Pressed\n");
	return 0;
}

// pause button released interrupt function
int on_pause_released(){
	rc_set_led(GREEN, OFF);
	printf("Pause Released\n");
	return 0;
}

// mode button pressed interrupt function
int on_mode_pressed(){
	rc_set_led(RED, ON);
	printf("Mode Pressed\n");
	return 0;
}

// mode button released interrupt function
int on_mode_released(){
	rc_set_led(RED,OFF);
	printf("Mode Released\n");
	return 0;
}

// main just assigns interrupt functions and waits to exit
int main(){
	if(rc_initialize()){
		printf("failed to initialize cape\n");
		return -1;
	}
	
	//Assign your own functions to be called when events occur
	rc_set_pause_pressed_func(&on_pause_pressed);
	rc_set_pause_released_func(&on_pause_released);
	rc_set_mode_pressed_func(&on_mode_pressed);
	rc_set_mode_released_func(&on_mode_released);
	
	printf("Press buttons to see response\n");
	
	//toggle leds till the program state changes
	while(rc_get_state()!=EXITING){
		rc_usleep(10000);
	}
	
	rc_cleanup();
	return 0;
}
