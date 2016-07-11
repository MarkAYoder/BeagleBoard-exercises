/* 
 *
 *  PRU Debug Program
 *  (c) Copyright 2011 by Arctica Technologies
 *  Written by Steven Anderson
 *
 */

#include <stdio.h>

#include "prudbg.h"

void printhelp()
{
	printf("Command help\n\n");
	printf("    Commands are case insensitive\n");
	printf("    Address and numeric values can be dec (ex 12), hex (ex 0xC), or octal (ex 014)\n");
	printf("    Memory addresses must be ba=byte addresses.  Suffix of i=instruction or d=data memory\n");
	printf("    Return without a command will rerun a previous d, dd, or di command while displaying the next block\n\n");

	printf("    BR [breakpoint_number [address]]\n");
	printf("    View or set an instruction breakpoint\n");
	printf("       'b' by itself will display current breakpoints\n");
	printf("       breakpoint_number is the breakpoint reference and ranges from 0 to %u\n", MAX_BREAKPOINTS - 1);
	printf("       address is the instruction byte address that the processor should stop at (instruction is not executed)\n");
	printf("       if no address is provided, then the breakpoint is cleared\n\n");

	printf("    D memory_location_ba [length]\n");
	printf("    Raw dump of PRU data memory (32-bit byte offset from beginning of full PRU memory block - all PRUs)\n\n");

	printf("    DD memory_location_ba [length]\n");
	printf("    Dump data memory (32-bit byte offset from beginning of PRU data memory)\n\n");

	printf("    DI memory_location_ba [length]\n");
	printf("    Dump instruction memory (32-bit byte offset from beginning of PRU instruction memory)\n\n");

	printf("    DIS memory_location_ba [length]\n");
	printf("    Disassemble instruction memory (32-bit byte offset from beginning of PRU instruction memory)\n\n");

	printf("    G\n");
	printf("    Start processor execution of instructions (at current IP)\n\n");

	printf("    GSS\n");
	printf("    Start processor execution using automatic single stepping - this allows running a program with breakpoints\n\n");

	printf("    HALT\n");
	printf("    Halt the processor\n\n");

	printf("    L memory_location_iba file_name\n");
	printf("    Load program file into instruction memory at 32-bit byte address provided (offset from beginning of instruction memory\n\n");

	printf("    PRU pru_number\n");
	printf("    Set the active PRU where pru_number ranges from 0 to %u\n", NUM_OF_PRU - 1);
	printf("    Some debugger commands do action on active PRU (such as halt and reset)\n\n");

	printf("    Q\n");
	printf("    Quit the debugger and return to shell prompt.\n\n");

	printf("    R\n");
	printf("    Display the current PRU registers.\n\n");

	printf("    RESET\n");
	printf("    Reset the current PRU\n\n");

	printf("    SS\n");
	printf("    Single step the current instruction.\n\n");

	printf("    WA [watch_num [address [value]]]\n");
	printf("    Clear or set a watch point\n");
	printf("      format 1:  wa - print watch point list\n");
	printf("      format 2:  wa watch_num - clear watch point watch_num\n");
	printf("      format 3:  wa watch_num address - set a watch point (watch_num) so any change at that byte address\n");
	printf("                 in data memory will be printed during program execution with gss command\n");
	printf("      format 4:  wa watch_num address value - set a watch point (watch_num) so that the program (run with gss) will\n");
	printf("                 be halted when the memory location equals the value\n");
	printf("      NOTE: for watchpoints to work, you must use gss command to run the program\n\n");

	printf("    WR memory_location_ba value1 [value2 [value3 ...]]\n");
	printf("    Write a 32-bit value to a raw (offset from beginning of full PRU memory block - all PRUs)\n");
	printf("    memory_location is a 32-bit byte index from the beginning of the PRU subsystem memory block\n\n");

	printf("    WRD memory_location_ba value1 [value2 [value3 ...]]\n");
	printf("    Write a 32-bit value to PRU data memory (32-bit byte offset from beginning of PRU data memory)\n\n");

	printf("    WRI memory_location_ba value1 [value2 [value3 ...]]\n");
	printf("    Write a 32-bit value to PRU instruction memory (32-bit byte offset from beginning of PRU instruction memory)\n\n");

	printf("A brief version of help is available with the command hb\n");

	printf("\n");
}

void printhelpbrief()
{
	printf("Command help\n\n");
	printf("    BR [breakpoint_number [address]] - View or set an instruction breakpoint\n");
	printf("    D memory_location_ba [length] - Raw dump of PRU data memory (32-bit byte offset from beginning of full PRU memory block - all PRUs)\n");
	printf("    DD memory_location_ba [length] - Dump data memory (32-bit byte offset from beginning of PRU data memory)\n");
	printf("    DI memory_location_ba [length] - Dump instruction memory (32-bit byte offset from beginning of PRU instruction memory)\n");
	printf("    DIS memory_location_ba [length] - Disassemble instruction memory (32-bit byte offset from beginning of PRU instruction memory)\n");
	printf("    G - Start processor execution of instructions (at current IP)\n");
	printf("    GSS - Start processor execution using automatic single stepping - this allows running a program with breakpoints\n");
	printf("    HALT - Halt the processor\n");
	printf("    L memory_location_iwa file_name - Load program file into instruction memory\n");
	printf("    PRU pru_number - Set the active PRU where pru_number ranges from 0 to %u\n", NUM_OF_PRU - 1);
	printf("    Q - Quit the debugger and return to shell prompt.\n");
	printf("    R - Display the current PRU registers.\n");
	printf("    RESET - Reset the current PRU\n");
	printf("    SS - Single step the current instruction.\n");
	printf("    WA [watch_num [address [value]]] - Clear or set a watch point\n");
	printf("    WR memory_location_ba value1 [value2 [value3 ...]] - Write a 32-bit value to a raw (offset from beginning of full PRU memory block)\n");
	printf("    WRD memory_location_ba value1 [value2 [value3 ...]] - Write a 32-bit value to PRU data memory for current PRU\n");
	printf("    WRI memory_location_ba value1 [value2 [value3 ...]] - Write a 32-bit value to PRU instruction memory for current PRU\n");

	printf("\n");
}

