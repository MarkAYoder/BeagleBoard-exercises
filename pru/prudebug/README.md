
Prudebug Version 0.25

(C) Copyright 2011, 2013 by Arctica Technologies
Written by Steven Anderson

Prudebug is a very small program that was initially intended to be 100-200 lines of code to start/stop the PRU and load a binary in the PRU.
As I worked through my PRU development project I added several addition features (some I needed for debugging the project, and a few just
because they seemed nice).  After completing the PRU coding project this program sat unused for about a year before I decided that maybe
someone else out there needed a PRU debugger.  After all, if you need a hard realtime process and you're using Linux, a PRU is an easy
way to go.

THIS PROGRAM HAS VERY LIMITED TESTING - USE AT YOUR OWN RISK.
I did test the features that I used, but there are many features I didn't need for my project.  I attempted a couple quick tests with the
unused features, but it would be very easy to miss something.  For example, I only used PRU0 for my coding, so very little testing was done
with PRU1.  I'm sure the user interface has bugs but I haven't hit them yet....it's easy to miss issues when you know how it's supposed 
to work.  As I continue to add code, I'll try to do a more complete job of testing, but I will continue to use feedback for locating most
bugs.


RELEASE NOTES for prudebug
---------------------------------------------------------------------
Version 0.24
	Improvements:
	
	Added support for UIO PRUSS driver
	Moved to dynamic processor selection - user can pick a processor on the command line
	Fixed watchpoints and breakpoints to support different values on different PRUs

Version 0.25
	Bug fixes provided by Shoji Suzuki
		Correction to the QBA instruction decode
		Fix backspace code for terminals using 0x7f
		Corrected issue with writing numbers greater than 0x7fffffff to PRU memory with the wr command


BUGS
---------------------------------------------------------------------
Please let me know if you find any bugs or you have comments on prudebug (steve.anderson@arcticatechnologies.com).  You can also log a bug
on the SourceForge page.  I will try to fix bugs as time permits.

	No known bugs at the time of v0.25 release


USE WITH PRUSS v2
---------------------------------------------------------------------
prudebug should work fine with the PRUSSv2.  It does not support any new features of the PRUSSv2, but I will try to add some as
time permits.  I have done some testing on both the AM1707 (PRUSSv1) and AM3358 (PRUSSv2) processors.


CONTRIBUTORS
---------------------------------------------------------------------
	Christian Joly - bug fixes, and modifications to make prudebug work with PRUSSv2.
	Shoji Suzuki - bug fixes for v0.25


INSTALLATION
---------------------------------------------------------------------
To build just run make in the source code directory (make sure you have the correct cross-compiler in place and in the path - 
arm-none-linux-gnueabi-gcc).  The binary is called prudebug.


USAGE
---------------------------------------------------------------------
```
Usage: prudebug [-a pruss-address] [-u] [-m] [-p processor]
    -a - pruss-address is the memory address of the PRU in ARM memory space
    -u - force the use of UIO to map PRU memory space
    -m - force the use of /dev/mem to map PRU memory space
    if neither the -u or -m options are used then it will try the UIO first
    -p - select processor to use (sets the PRU memory locations)
        AM1707 - AM1707
        AM335X - AM335x
        AM57X1 - AM57x1
        AM57X2 - AM57x2
```

Generally the -a option should not be used.  If it is used, then prudebug will use the -a address for the PRU base with
the selected processor as the various PRU subsystem offsets.  -u and -m control the way the PRU base address is mapped for
program access (either the /dev/mem or /dev/uio* device).  If -u or -m are selected then it will only used the selected
method or fail.  If neither the -u or -m are selected then prudebug will try to use the UIO device driver, and if that fails
then it will use /dev/mem.  The -p option allows you to select the processor.  If your processor is not listed then determine
if one of the listed processors has compatible PRU (same base address and PRU subsystem offsets).  If not, you'll need to
modify prudbg.c and prudbg.h (see remarks near the beginning of prudbg.c).  If you do add to the list of processors, please
send me the diff so I can add it into future releases.


COMMAND HELP
I would like to spend a little time writing up a command document, but in the meantime the following will have to do.
The command line takes the command 'help' to provide a detailed help, and 'hb' for a brief help.  Listed below is both.

PRU0> hb
Command help

    BR [breakpoint_number [address]] - View or set an instruction breakpoint
    D memory_location_wa [length] - Raw dump of PRU data memory (32-bit word offset from beginning of full PRU memory block - all PRUs)
    DD memory_location_wa [length] - Dump data memory (32-bit word offset from beginning of PRU data memory)
    DI memory_location_wa [length] - Dump instruction memory (32-bit word offset from beginning of PRU instruction memory)
    DIS memory_location_wa [length] - Disassemble instruction memory (32-bit word offset from beginning of PRU instruction memory)
    G - Start processor execution of instructions (at current IP)
    GSS - Start processor execution using automatic single stepping - this allows running a program with breakpoints
    HALT - Halt the processor
    L memory_location_iwa file_name - Load program file into instruction memory
    PRU pru_number - Set the active PRU where pru_number ranges from 0 to 1
    Q - Quit the debugger and return to shell prompt.
    R - Display the current PRU registers.
    RESET - Reset the current PRU
    SS - Single step the current instruction.
    WA [watch_num [address [value]]] - Clear or set a watch point
    WR memory_location_wa value1 [value2 [value3 ...]] - Write a 32-bit value to a raw (offset from beginning of full PRU memory block)
    WRD memory_location_wa value1 [value2 [value3 ...]] - Write a 32-bit value to PRU data memory for current PRU
    WRI memory_location_wa value1 [value2 [value3 ...]] - Write a 32-bit value to PRU instruction memory for current PRU

PRU0> help
Command help

    Commands are case insensitive
    Address and numeric values can be dec (ex 12), hex (ex 0xC), or octal (ex 014)
    Memory addresses can be wa=32-bit word address, ba=byte address.  Suffix of i=instruction or d=data memory
    Return without a command will rerun a previous d, dd, or di command while displaying the next block

    BR [breakpoint_number [address]]
    View or set an instruction breakpoint
       'b' by itself will display current breakpoints
       breakpoint_number is the breakpoint reference and ranges from 0 to 4
       address is the instruction word address that the processor should stop at (instruction is not executed)
       if no address is provided, then the breakpoint is cleared

    D memory_location_wa [length]
    Raw dump of PRU data memory (32-bit word offset from beginning of full PRU memory block - all PRUs)

    DD memory_location_wa [length]
    Dump data memory (32-bit word offset from beginning of PRU data memory)

    DI memory_location_wa [length]
    Dump instruction memory (32-bit word offset from beginning of PRU instruction memory)

    DIS memory_location_wa [length]
    Disassemble instruction memory (32-bit word offset from beginning of PRU instruction memory)

    G
    Start processor execution of instructions (at current IP)

    GSS
    Start processor execution using automatic single stepping - this allows running a program with breakpoints

    HALT
    Halt the processor

    L memory_location_iwa file_name
    Load program file into instruction memory at 32-bit word address provided (offset from beginning of instruction memory

    PRU pru_number
    Set the active PRU where pru_number ranges from 0 to 1
    Some debugger commands do action on active PRU (such as halt and reset)

    Q
    Quit the debugger and return to shell prompt.

    R
    Display the current PRU registers.

    RESET
    Reset the current PRU

    SS
    Single step the current instruction.

    WA [watch_num [address [value]]]
    Clear or set a watch point
      format 1:  wa - print watch point list
      format 2:  wa watch_num - clear watch point watch_num
      format 3:  wa watch_num address - set a watch point (watch_num) so any change at that word address
                 in data memory will be printed during program execution with gss command
      format 4:  wa watch_num address value - set a watch point (watch_num) so that the program (run with gss) will
                 be halted when the memory location equals the value
      NOTE: for watchpoints to work, you must use gss command to run the program

    WR memory_location_wa value1 [value2 [value3 ...]]
    Write a 32-bit value to a raw (offset from beginning of full PRU memory block - all PRUs)
    memory_location is a 32-bit word index from the beginning of the PRU subsystem memory block

    WRD memory_location_wa value1 [value2 [value3 ...]]
    Write a 32-bit value to PRU data memory (32-bit word offset from beginning of PRU data memory)

    WRI memory_location_wa value1 [value2 [value3 ...]]
    Write a 32-bit value to PRU instruction memory (32-bit word offset from beginning of PRU instruction memory)

A brief version of help is available with the command hb




