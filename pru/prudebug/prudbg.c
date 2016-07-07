/* 
 *
 *  PRU Debug Program
 *  (c) Copyright 2011, 2013 by Arctica Technologies
 *  Written by Steven Anderson
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <termios.h>
#include <sys/ioctl.h>

#include "prudbg.h"
#include "uio.h"


// global variable definitions
unsigned int			*pru;
unsigned int			pru_inst_base[MAX_NUM_OF_PRUS];
unsigned int			pru_ctrl_base[MAX_NUM_OF_PRUS];
unsigned int			pru_data_base[MAX_NUM_OF_PRUS];
unsigned int			pru_num = 0;
unsigned int			last_offset, last_addr, last_len, last_cmd;
struct breakpoints		bp[MAX_NUM_OF_PRUS][MAX_BREAKPOINTS];
struct watchvariable		wa[MAX_NUM_OF_PRUS][MAX_WATCH];

// processor database
typedef struct offsets_tag {
	unsigned int		pruss_inst;
	unsigned int		pruss_data;
	unsigned int		pruss_ctrl;
} offsets_t;

struct pdb_tag {
	char			processor[MAX_PROC_NAME];
	char			short_name[MAX_PROC_NAME];
	unsigned int		pruss_address;
	unsigned int		pruss_len;
	unsigned int		num_of_pruss;
	const offsets_t		offsets[MAX_NUM_OF_PRUS];
} pdb[] = {

// The following is a "database" of available processors.
// To add another processor please copy one of the existing structures to
// the end before the END MARKER structure.  "processor" is the long name
// for the processor (used for displaying info), "short_name" is used to
// select a processor at the command prompt (should be short and no spaces),
// "pruss_address" is the byte address of the beginning of the PRUSS memory
// space on the ARM, "pruss_len" is the memory allocated starting at the
// pruss_address address, "num_of_pruss" is the number of PRUs in the ARM
// processor (currently 2 is the only valid value), and "offsets" is an
// array of 32-bit word address/index values used to locate the instruction,
// data, and control memory locations for a specific PRU.  This offsets
// array much contain num_of_pruss entries.  If you add a processor to
// this structure then you should also add a DEFINE to the beginning of
// the prudbg.h file to represent the processor index in the structure
// array.  This is only used for the DEFAULT_PROCESSOR_INDEX in the
// prudbg.h file (this sets the processor used if none is selected
// on the command line).

	{
		.processor 	= "AM1707",
		.short_name 	= "AM1707",
		.pruss_address 	= 0x01C30000,
		.pruss_len 	= 0x20000,
		.num_of_pruss	= 2,
		.offsets	= {
			{
				.pruss_inst	= 0x2000,
				.pruss_data	= 0x0000,
				.pruss_ctrl	= 0x1C00
			},
			{
				.pruss_inst	= 0x3000,
				.pruss_data	= 0x0800,
				.pruss_ctrl	= 0x1E00
			}
		}
	},
	{
		.processor 	= "AM335x",
		.short_name 	= "AM335X",
		.pruss_address 	= 0x4A300000,
		.pruss_len 	= 0x40000,
		.num_of_pruss	= 2,
		.offsets	= {
			{
				.pruss_inst	= 0xD000,
				.pruss_data	= 0x0000,
				.pruss_ctrl	= 0x8800
			},
			{
				.pruss_inst	= 0xE000,
				.pruss_data	= 0x0800,
				.pruss_ctrl	= 0x9000
			}
		}
	},
	{	// end marker
		.processor	= "NONE",
		.short_name	= "NONE",
		.num_of_pruss	= 0
	}
};

int strcmpci(char *str1, char *str2, int m) {
	unsigned int		i;
	char			c1, c2;
	int			r;

	r = 1;
	for (i=0; str1[i] != 0 && i<m; i++) {
		c1 = str1[i];
		c2 = str2[i];
		if (c1>96 && c1<123) c1 = c1 - 32;
		if (c2>96 && c2<123) c2 = c2 - 32;
		if (c1 != c2) r = 0;
	}
	if ((i==m) || (str2[i] != 0)) r = 0;
	
	return r;
}

// main entry point for program
int main(int argc, char *argv[])
{
	int			fd;
	char			prompt_str[20];
	char			cmd[MAX_CMD_LEN], cmdargs[MAX_CMDARGS_LEN];
	unsigned int		argptrs[MAX_ARGS], numargs;
	struct termios		oldT, newT;
	unsigned int		i;
	unsigned int		addr, len, bpnum, offset, wanum, value;
	int			opt;
	unsigned long		opt_pruss_addr;
	int			pru_access_mode, pi, pitemp;
	char			uio_dev_file[50];

	// say hello
	printf ("PRU Debugger v0.25\n");
	printf ("(C) Copyright 2011, 2013 by Arctica Technologies.  All rights reserved.\n");
	printf ("Written by Steven Anderson\n");
	printf ("\n");

	// get command line options
	opt_pruss_addr = 0;
	pru_access_mode = ACCESS_GUESS;
	pi = DEFAULT_PROCESSOR_INDEX;
	while ((opt = getopt(argc, argv, "?a:p:um")) != -1) {
		switch (opt) {
			case 'a':
				opt_pruss_addr = strtol(optarg, NULL, 0);
				break;
				
			case 'u':
				pru_access_mode = ACCESS_UIO;
				break;
				
			case 'm':
				pru_access_mode = ACCESS_MEM;
				break;
				
			case 'p':
				pitemp = -1;
				for(i=0; pdb[i].num_of_pruss != 0; i++) if (strcmpci(optarg, pdb[i].short_name, MAX_PROC_NAME)) pitemp = i;
				
				if (pitemp == -1) {
					printf("WARNING: unrecognized processor - will use the compiled-in default processor.\n\n");
				} else {
					pi = pitemp;
				}
				break;
				
			case '?':
			default: /* '?' */
				printf("Usage: prudebug [-a pruss-address] [-u] [-m] [-p processor]\n");
				printf("    -a - pruss-address is the memory address of the PRU in ARM memory space\n");
				printf("    -u - force the use of UIO to map PRU memory space\n");
				printf("    -m - force the use of /dev/mem to map PRU memory space\n");
				printf("    if neither the -u or -m options are used then it will try the UIO first\n");
				
				printf("    -p - select processor to use (sets the PRU memory locations)\n");
				for(i=0; pdb[i].num_of_pruss != 0; i++) {
					printf("        %s - %s\n", pdb[i].short_name, pdb[i].processor);
				}
				
				return(-1);
		}
	}
	
	// setup PRU memory offsets
	for (i=0; i<pdb[pi].num_of_pruss ;i++) {
		pru_inst_base[i] = pdb[pi].offsets[i].pruss_inst;
		pru_data_base[i] = pdb[pi].offsets[i].pruss_data;
		pru_ctrl_base[i] = pdb[pi].offsets[i].pruss_ctrl;
	}
	
	// if user hasn't requested a different PRU base address on the CLI, then use the PRU DB address
	if (opt_pruss_addr == 0) opt_pruss_addr = pdb[pi].pruss_address;

	// determine how to obtain the PRU base memory pointer (/dev/mem or a UIO PRUSS driver file - /dev/uio*)
	if (pru_access_mode == ACCESS_GUESS || pru_access_mode == ACCESS_UIO) {
		// get the UIO info (a UIO device file for the PRUSS)
		uio_getprussfile(uio_dev_file);
		if (uio_dev_file[0] != 0) {
			// there is a valid UIO/PRUSS file so open it and use the pointer
			fd = open (uio_dev_file, O_RDWR | O_SYNC);
			if (fd == -1) {
				printf ("ERROR: could not open /dev/mem.\n\n");
				return 1;
			}
			pru = mmap (0, pdb[pi].pruss_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
			if (pru == MAP_FAILED) {
				printf ("ERROR: could not map memory.\n\n");
				return 1;
			}
			close(fd);
			printf ("Using UIO PRUSS device.\n");
		} else if (pru_access_mode == ACCESS_UIO) {
			// user wanted only UIO device and none found - generate an error and exit
			printf ("ERROR:  UIO PRUSS device requested and none found.\n\n");
			return (1);
		} else {
			// no valid UIO device file and user wants a guess so open /dev/mem
			fd = open ("/dev/mem", O_RDWR | O_SYNC);
			if (fd == -1) {
				printf ("ERROR: could not open /dev/mem.\n\n");
				return 1;
			}
			pru = mmap (0, pdb[pi].pruss_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, opt_pruss_addr);
			if (pru == MAP_FAILED) {
				printf ("ERROR: could not map memory.\n\n");
			return 1;
			}
			close(fd);
			printf ("Using /dev/mem device.\n");
		}
	} else {
		// user requested the use of /dev/mem
		fd = open ("/dev/mem", O_RDWR | O_SYNC);
		if (fd == -1) {
			printf ("ERROR: could not open /dev/mem.\n\n");
			return 1;
		}
		pru = mmap (0, pdb[pi].pruss_len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, opt_pruss_addr);
		if (pru == MAP_FAILED) {
			printf ("ERROR: could not map memory.\n\n");
			return 1;
		}
		close(fd);
		printf ("Using /dev/mem device.\n");
	}

	// get memory pointer for PRU from /dev/mem

	// clear breakpoints
	for (i=0; i<MAX_BREAKPOINTS; i++) {
		bp[pru_num][i].state = BP_UNUSED;
	}

	// clear watch variables
	for (i=0; i<MAX_WATCH; i++) {
		wa[pru_num][i].state = WA_UNUSED;
	}

	// print some useful info
	printf("Processor type		%s\n", pdb[pi].processor);
	printf("PRUSS memory address	0x%08x\n", opt_pruss_addr);
	printf("PRUSS memory length	0x%08x\n\n", pdb[pi].pruss_len);
	printf("         offsets below are in 32-bit word addresses (not ARM byte addresses)\n");
	printf("         PRU            Instruction    Data         Ctrl\n");
	for (i=0; i<pdb[pi].num_of_pruss; i++) {
		printf("         %-15d0x%08x     0x%08x   0x%08x\n", i, pdb[pi].offsets[i].pruss_inst, pdb[pi].offsets[i].pruss_data, pdb[pi].offsets[i].pruss_ctrl);
	}
	printf("\n");

	// setup the terminal for more flexible IO
	ioctl(0,TCGETS,&oldT);
	newT=oldT;
	newT.c_lflag &= ~ECHO;
	newT.c_lflag &= ~ICANON;
	ioctl(0,TCSETS,&newT);


	// Command prompt handler
	do {
		// get command from user
		sprintf(prompt_str, "PRU%u> ", pru_num);
		cmd_input(prompt_str, cmd, cmdargs, argptrs, &numargs);

		// do something with command info
		if (!strcmp(cmd, "?") || !strcmp(cmd, "HELP")) {		// HELP - help command
			last_cmd = LAST_CMD_NONE;
			printhelp();
		}

		else if (!strcmp(cmd, "HB")) {					// brief HELP
			last_cmd = LAST_CMD_NONE;
			printhelpbrief();			
		}

		else if (!strcmp(cmd, "BR")) {					// BR - Breakpoint command
			last_cmd = LAST_CMD_NONE;
			if (numargs == 0) {
				cmd_print_breakpoints();
			} else if (numargs == 1) {
				bpnum = strtol(&cmdargs[argptrs[0]], NULL, 0);
				if (bpnum < MAX_BREAKPOINTS) {
					cmd_clear_breakpoint (bpnum);
				} else {
					printf("ERROR: breakpoint number must be equal to or between 0 and %u\n", MAX_BREAKPOINTS-1);
				}
			} else if (numargs == 2) {
				bpnum = strtol(&cmdargs[argptrs[0]], NULL, 0);
				addr = strtol(&cmdargs[argptrs[1]], NULL, 0);
				if (bpnum < MAX_BREAKPOINTS) {
					cmd_set_breakpoint (bpnum, addr);
				} else {
					printf("ERROR: breakpoint number must be equal to or between 0 and %u\n", MAX_BREAKPOINTS-1);
				}
			} else {
				printf("ERROR: invalid breakpoint command\n");
			}
		}

		else if ((!strcmp(cmd, "D")) || (!strcmp(cmd, "DD")) || (!strcmp(cmd, "DI"))) {	// D - Dump command
			if (numargs > 2) {
				printf("ERROR: too many arguments\n");
			} else {
				if (numargs == 2) {
					addr = strtol(&cmdargs[argptrs[0]], NULL, 0);
					len = strtol(&cmdargs[argptrs[1]], NULL, 0);
				} else if (numargs == 0) {
					addr = 0;
					len = 16;
				} else {
					addr = strtol(&cmdargs[argptrs[0]], NULL, 0);
					len = 16;
				}
				if ((addr < 0) || (addr > MAX_PRU_MEM - 1) || (len < 0) || (addr+len > MAX_PRU_MEM)) {
					printf("ERROR: arguments out of range.\n");
				} else if (numargs > 2) {
					printf("ERROR: Incorrect format.  Please use help command to get command details.\n");
				} else {
					if (!strcmp(cmd, "DD")) {
						offset = pru_data_base[pru_num];
						last_cmd = LAST_CMD_DD;
					} else if (!strcmp(cmd, "DI")) {
						offset = pru_inst_base[pru_num];
						last_cmd = LAST_CMD_DI;
					} else {
						offset = 0;
						last_cmd = LAST_CMD_D;
					}
					last_offset = offset;
					last_addr = addr + len;
					last_len = len;
					printf ("Absolute addr = 0x%04x, offset = 0x%04x, Len = %u\n", addr + offset, addr, len);
					cmd_d(offset, addr, len);
				}
			}
		}

		else if (!strcmp(cmd, "DIS")) {						// DIS - disassemble command
			if (numargs > 2) {
				printf("ERROR: too many arguments\n");
			} else {
				if (numargs == 2) {
					addr = strtol(&cmdargs[argptrs[0]], NULL, 0);
					len = strtol(&cmdargs[argptrs[1]], NULL, 0);
				} else if (numargs == 0) {
					addr = 0;
					len = 16;
				} else {
					addr = strtol(&cmdargs[argptrs[0]], NULL, 0);
					len = 16;
				}
				if ((addr < 0) || (addr > MAX_PRU_MEM - 1) || (len < 0) || (addr+len > MAX_PRU_MEM)) {
					printf("ERROR: arguments out of range.\n");
				} else if (numargs > 2) {
					printf("ERROR: Incorrect format.  Please use help command to get command details.\n");
				} else {
					offset = pru_inst_base[pru_num];
					last_cmd = LAST_CMD_DIS;

					last_offset = offset;
					last_addr = addr + len;
					last_len = len;
					printf ("Absolute addr = 0x%04x, offset = 0x%04x, Len = %u\n", addr + offset, addr, len);
					cmd_dis(offset, addr, len);
				}
			}
		}

		else if (!strcmp(cmd, "G")) {					// G - Start program
			last_cmd = LAST_CMD_NONE;
			if (numargs > 1) {
				printf("ERROR: too many arguments\n");
			} else if (numargs == 0) {
				// start processor
				cmd_run();
			} else {
				// set instruction pointer
				addr = strtol(&cmdargs[argptrs[0]], NULL, 0);

				// start processor
//				cmd_run_at(addr);
				printf("NOT IMPLEMENTED YET.\n");
			}
		}

		else if (!strcmp(cmd, "GSS")) {					// GSS - Start program using single stepping to provde BP/Watch
			last_cmd = LAST_CMD_NONE;
			if (numargs > 0) {
				printf("ERROR: too many arguments\n");
			} else {
				// halt the processor
				cmd_runss();
			}
		}

		else if (!strcmp(cmd, "HALT")) {					// HALT - Halt PRU
			last_cmd = LAST_CMD_NONE;
			if (numargs > 0) {
				printf("ERROR: too many arguments\n");
			} else {
				// halt the processor
				cmd_halt();
			}
		}

		else if (!strcmp(cmd, "L")) {					// L - Load PRU program
			last_cmd = LAST_CMD_NONE;
			if (numargs != 2) {
				printf("ERROR: incorrect number of arguments\n");
			} else {
				addr = strtol(&cmdargs[argptrs[0]], NULL, 0);
				cmd_loadprog(addr, &cmdargs[argptrs[1]]);
			}
		}

		else if (!strcmp(cmd, "PRU")) {					// PRU - Select the active PRU
			last_cmd = LAST_CMD_NONE;
			if (numargs != 1) {
				printf("ERROR: incorrect number of arguments\n");
			} else {
				pru_num = strtol(&cmdargs[argptrs[0]], NULL, 0);
				printf("Active PRU is PRU%u.\n\n", pru_num);
			}
		}

		else if (!strcmp(cmd, "R")) {					// R - Print PRU registers
			last_cmd = LAST_CMD_NONE;
			if (numargs != 0) {
				printf("ERROR: incorrect number of arguments\n");
			} else {
				cmd_printregs();
			}
		}		

		else if (!strcmp(cmd, "RESET")) {					// RESET - Reset PRU
			last_cmd = LAST_CMD_NONE;
			if (numargs > 0) {
				printf("ERROR: too many arguments\n");
			} else {
				// reset the processor
				cmd_soft_reset();
				printf("\n");
			}
		}

		else if (!strcmp(cmd, "SS")) {					// SS - Single step
			last_cmd = LAST_CMD_SS;
			if (numargs > 0) {
				printf("ERROR: too many arguments\n");
			} else {
				// reset the processor
				cmd_single_step();
			}
		}

		else if (!strcmp(cmd, "WA")) {					// WA - Watch command
			last_cmd = LAST_CMD_NONE;
			if (numargs == 0) {
				cmd_print_watch();
			} else if (numargs == 1) {
				wanum = strtol(&cmdargs[argptrs[0]], NULL, 0);
				if (wanum < MAX_WATCH) {
					cmd_clear_watch (wanum);
				} else {
					printf("ERROR: breakpoint number must be equal to or between 0 and %u\n", MAX_WATCH-1);
				}
			} else if (numargs == 2) {
				wanum = strtol(&cmdargs[argptrs[0]], NULL, 0);
				addr = strtol(&cmdargs[argptrs[1]], NULL, 0);
				if (wanum < MAX_WATCH) {
					cmd_set_watch_any (wanum, addr);
				} else {
					printf("ERROR: breakpoint number must be equal to or between 0 and %u\n", MAX_WATCH-1);
				}
			} else if (numargs == 3) {
				wanum = strtol(&cmdargs[argptrs[0]], NULL, 0);
				addr = strtol(&cmdargs[argptrs[1]], NULL, 0);
				value = strtol(&cmdargs[argptrs[2]], NULL, 0);
				if (wanum < MAX_WATCH) {
					cmd_set_watch (wanum, addr, value);
				} else {
					printf("ERROR: breakpoint number must be equal to or between 0 and %u\n", MAX_WATCH-1);
				}
			} else {
				printf("ERROR: invalid breakpoint command\n");
			}
		}

		else if ((!strcmp(cmd, "WR")) || (!strcmp(cmd, "WRD")) || (!strcmp(cmd, "WRI"))) {  // WR - Write Raw
			last_cmd = LAST_CMD_NONE;
			addr = strtol(&cmdargs[argptrs[0]], NULL, 0);
			if (numargs < 2) {
				printf("ERROR: too few arguments\n");
			} else {
				if ((addr < 0) || (addr > MAX_PRU_MEM - 1)) {
					printf("ERROR: arguments out of range.\n");
				} else {
					if (!strcmp(cmd, "WRD")) {
						offset = pru_data_base[pru_num];
					} else if (!strcmp(cmd, "WRI")) {
						offset = pru_inst_base[pru_num];
					} else {
						offset = 0;
					}
					printf("Write to absolute address 0x%04x\n", offset+addr);
					for (i=1; i<numargs; i++) pru[offset+addr+i-1] = (unsigned int) (strtoll(&cmdargs[argptrs[i]], NULL, 0) & 0xFFFFFFFF);
				}
			}
		}

		else if (!strcmp(cmd, "Q")) {					// dummy so it's a valid command
		}

		else if (!strcmp(cmd, "")) {					// repeat display command option
			switch(last_cmd) {
				case LAST_CMD_D:
				case LAST_CMD_DD:
				case LAST_CMD_DI:
					printf ("Absolute addr = 0x%04x, offset = 0x%04x, Len = %u\n", last_addr + last_offset, last_addr, last_len);
					cmd_d(last_offset, last_addr, last_len);
					last_addr += last_len;
					break;

				case LAST_CMD_SS:
					cmd_single_step();
					break;

				default:
					break;
			}
		}

		else {
			printf("Invalid command.\n\n");
		}

	} while (strcmp(cmd, "Q"));

	printf("\nGoodbye.\n\n");

	// restore terminal IO settings
	ioctl(0,TCSETS,&oldT);

	return 0;
}

