/* 
 *
 *  PRU Debug Program - command input function
 *  (c) Copyright 2011, 2013 by Arctica Technologies
 *  Written by Steven Anderson
 *
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <termios.h>
#include <sys/ioctl.h>

#include "prudbg.h"

int cmd_input(char *prompt, char *cmd, char *cmdargs, unsigned int *argptrs, unsigned int *numargs)
{
	unsigned int		i, j, full_len, on_zero;
	char			c, last_char;
	char			buf[MAX_COMMAND_LINE];

	// print prompt
	printf("%s", prompt);

	// collect command until space or return
	i = 0;
	do {
		c = getchar();

		// check for backspace
		if (c == 0x08 || c == 0x7F) {
			if (i != 0) {
				putchar(0x08);
				putchar(' ');
				putchar(0x08);
				i--;
			}
		// just a normal character
		} else {
			buf[i] = c;
			printf("%c", buf[i]);
			if (i < (MAX_COMMAND_LINE - 1)) i++;
		}
		
	} while (c != '\n');
	buf[i-1] = 0;

	// replace spaces and return with zeros
	full_len = strlen(buf);
	for (i=0; i<full_len; i++) if (buf[i] == ' ') buf[i] = 0;

	// copy command (first word) to cmd argument and shift to upper case
	for (i=0; i<(strlen(buf)+1); i++) cmd[i] = toupper(buf[i]);

	// build index array and count number of arguments
	for (i=strlen(cmd), on_zero=TRUE, numargs[0]=0; i<full_len; i++) {
		if (on_zero) {
			if (buf[i] != 0) {
				on_zero = FALSE;
				argptrs[numargs[0]++] = i;
			}
		} else {
			if (buf[i] == 0) on_zero = TRUE;
		}
	}

	for (i=0; i<full_len+1; i++) cmdargs[i] = buf[i];

	return 0;
}

