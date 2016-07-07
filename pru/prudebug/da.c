/* 
 *
 *  PRU Debug Program - disassembly routines
 *  (c) Copyright 2011 by Arctica Technologies
 *  Written by Steven Anderson
 *
 */

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <sys/select.h>

#include "prudbg.h"

// util function to decode BurstLen in Format 6 instructions
void GetBurstLen(char *tempstr, unsigned int BurstLen)
{
	if (BurstLen < 124) {
		sprintf(tempstr, "%u", BurstLen+1);
	} else if (BurstLen == 124) {
		sprintf(tempstr, "b0");
	} else if (BurstLen == 125) {
		sprintf(tempstr, "b1");
	} else if (BurstLen == 126) {
		sprintf(tempstr, "b2");
	} else if (BurstLen == 127) {
		sprintf(tempstr, "b3");
	} else {
		sprintf(tempstr, "XX");
	}
}

// disassemble the inst instruction and place string in str
void disassemble(char *str, unsigned int inst)
{
	unsigned short		Imm;
	unsigned char		OP, ALUOP, Rs2Sel, Rs2, Rs1Sel, Rs1, RdSel, Rd, IO, Imm2, SUBOP, Test;
	unsigned char		LoadStore, BurstLen, RxByteAddr, Rx, Ro, RoSel, Rb;
	short			BrOff;
	char			tempstr[50];

	char			*f1_inst[] = {"ADD", "ADC", "SUB", "SUC", "LSL", "LSR", "RSB", "RSC", "AND", "OR", "XOR", "NOT", "MIN", "MAX", "CLR", "SET"};
	char			*f2_inst[] = {
				"JMP", "JAL", "LDI", "LMBD", "SCAN", "HALT",
				"RESERVED", "RESERVED", "RESERVED", "RESERVED", "RESERVED", "RESERVED", "RESERVED", "RESERVED", "RESERVED", 
				"SLP"
				};
	char			*f4_inst[] = {"xx", "LT", "EQ", "LE", "GT", "NE", "GE", "A"};
	char			*f5_inst[] = {"xx", "BC", "BS", "xx"};
	char			*f6_7_inst[] = {"SBBO", "LBBO"};
	char			*f6_4_inst[] = {"SBCO", "LBCO"};
	char			*sis[] = {".b0", ".b1", ".b2", ".b3", ".w0", ".w1", ".w2", ""};
	char			*bytenum[] = {"", ".b1", ".b2", ".b3"};

	OP = (inst & 0xE0000000) >> 29;

	switch (OP) {
		case 0:		// format 1
			ALUOP = (inst & 0x1E000000) >> 25;
			IO = (inst & 0x01000000) >> 24;
			Rs1Sel = (inst & 0x0000E000) >> 13;
			Rs1 = (inst & 0x00001F00) >> 8;
			RdSel = (inst & 0x000000E0) >> 5;
			Rd = (inst & 0x0000001F);
			if (IO) {
				Imm2 = (inst & 0x00FF0000) >> 16;
				sprintf(str, "%s R%u%s, R%u%s, 0x%02x", f1_inst[ALUOP], Rd, sis[RdSel], Rs1, sis[Rs1Sel], Imm2);
			} else {
				Rs2Sel = (inst & 0x00E00000) >> 21;
				Rs2 = (inst & 0x001F0000) >> 16;
				sprintf(str, "%s R%u%s, R%u%s, R%u%s", f1_inst[ALUOP], Rd, sis[RdSel], Rs1, sis[Rs1Sel], Rs2, sis[Rs2Sel]);
			}
			break;

		case 1:		// format 2
			SUBOP = (inst & 0x1E000000) >> 25;
			switch (SUBOP) {
				case 0:			// JMP & JAL
				case 1:
					IO = (inst & 0x01000000) >> 24;
					RdSel = (inst & 0x000000E0) >> 5;
					Rd = (inst & 0x0000001F);
					if (IO) {
						Imm = (inst & 0x00FFFF00) >> 8;
						if (SUBOP == 0)
							sprintf(str, "%s 0x%04x", f2_inst[SUBOP], Imm);
						else
							sprintf(str, "%s R%u%s, 0x%04x", f2_inst[SUBOP], Rd, sis[RdSel], Imm);
					} else {
						Rs2Sel = (inst & 0x00E00000) >> 21;
						Rs2 = (inst & 0x001F0000) >> 16;
						if (SUBOP == 0)
							sprintf(str, "%s R%u%s", f2_inst[SUBOP], Rs2, sis[Rs2Sel]);
						else
							sprintf(str, "%s R%u%s, R%u%s", f2_inst[SUBOP], Rd, sis[RdSel], Rs2, sis[Rs2Sel]);
					}
					break;

				case 2:  // LDI
					Imm = (inst & 0x00FFFF00) >> 8;
					RdSel = (inst & 0x000000E0) >> 5;
					Rd = (inst & 0x0000001F);
					sprintf(str, "%s R%u%s, 0x%04x", f2_inst[SUBOP], Rd, sis[RdSel], Imm);
					break;

				case 3:  // LMBD
					IO = (inst & 0x01000000) >> 24;
					Rs1Sel = (inst & 0x0000E000) >> 13;
					Rs1 = (inst & 0x00001F00) >> 8;
					RdSel = (inst & 0x000000E0) >> 5;
					Rd = (inst & 0x0000001F);
					Rs2Sel = (inst & 0x00E00000) >> 21;
					Rs2 = (inst & 0x001F0000) >> 16;
					Imm2 = (inst & 0x00FF0000) >> 16;
					
					if (IO) {
						sprintf(str, "%s R%u%s, R%u%s, 0x%04x", f2_inst[SUBOP], Rd, sis[RdSel], Rs1, sis[Rs1Sel], Imm2);
					} else {
						sprintf(str, "%s R%u%s, R%u%s, R%u%s", f2_inst[SUBOP], Rd, sis[RdSel], Rs1, sis[Rs1Sel], Rs2, sis[Rs2Sel]);
					}

					break;

				case 4:  // SCAN
					IO = (inst & 0x01000000) >> 24;
					RdSel = (inst & 0x000000E0) >> 5;
					Rd = (inst & 0x0000001F);
					Rs2Sel = (inst & 0x00E00000) >> 21;
					Rs2 = (inst & 0x001F0000) >> 16;
					Imm2 = (inst & 0x00FF0000) >> 16;

					if (IO) {
						sprintf(str, "%s R%u%s, 0x%04x", f2_inst[SUBOP], Rd, sis[RdSel], Rs1, sis[Rs1Sel], Imm2);
					} else {
						sprintf(str, "%s R%u%s, R%u%s", f2_inst[SUBOP], Rd, sis[RdSel], Rs2, sis[Rs2Sel]);
					}

					break;

				case 5:  // HALT
					sprintf(str, "%s", f2_inst[SUBOP]);
					break;

				case 15:  // SLP
					Imm = (inst & 0x00800000) >> 23;
					sprintf(str, "%s %u", f2_inst[SUBOP], Imm);
					break;

				default:
					sprintf(str, "UNKNOWN-F2");
					break;
			}
			break;

		case 2:  // Format 4a & 4b - Quick Arithmetic Test and Branch
		case 3:
			Test = (inst & 0x38000000) >> 27;
			IO = (inst & 0x01000000) >> 24;
			Rs2Sel = (inst & 0x00E00000) >> 21;
			Rs2 = (inst & 0x001F0000) >> 16;
			Rs1Sel = (inst & 0x0000E000) >> 13;
			Rs1 = (inst & 0x00001F00) >> 8;
			Imm = (inst & 0x00FF0000) >> 16;
			BrOff = ((inst & 0x06000000) >> 17) | (inst & 0x000000FF);
			if (BrOff & 0x0200) BrOff |= 0xFC00;

			if (Test == 7) {
				sprintf(str, "QBA %d", BrOff);
			} else {
				if (IO) {
					sprintf(str, "QB%s %d, R%u%s, %u", f4_inst[Test], BrOff, Rs1, sis[Rs1Sel], Imm);
				} else {
					sprintf(str, "QB%s %d, R%u%s, R%u%s", f4_inst[Test], BrOff, Rs1, sis[Rs1Sel], Rs2, sis[Rs2Sel]);
				}
			}

			break;

		case 6:  // Format 5 - Quick bit test and banch instructions
			Test = (inst & 0x18000000) >> 27;
			IO = (inst & 0x01000000) >> 24;
			Rs2Sel = (inst & 0x00E00000) >> 21;
			Rs2 = (inst & 0x001F0000) >> 16;
			Rs1Sel = (inst & 0x0000E000) >> 13;
			Rs1 = (inst & 0x00001F00) >> 8;
			Imm = (inst & 0x001F0000) >> 16;
			BrOff = ((inst & 0x06000000) >> 17) | (inst & 0x000000FF);
			if (BrOff & 0x0200) BrOff |= 0xFC00;

			if (IO) {
				sprintf(str, "QB%s %d, R%u%s, %u", f5_inst[Test], BrOff, Rs1, sis[Rs1Sel], Imm);
			} else {
				sprintf(str, "QB%s %d, R%u%s, R%u%s", f5_inst[Test], BrOff, Rs1, sis[Rs1Sel], Rs2, sis[Rs2Sel]);
			}
			
			break;

		case 4:
		case 7:  // Format 6 - LBBO/SBBO/LBCO/SBCO instructions
			LoadStore = (inst & 0x10000000) >> 28;
			BurstLen = ((inst & 0x0E000000) >> 21) | ((inst & 0x0000E000) >> 12) | ((inst & 0x00000080) >> 7);
			IO = (inst & 0x01000000) >> 24;
			RxByteAddr = (inst & 0x00000060) >> 5;
			Rx = (inst & 0x0000001F);
			RoSel = (inst & 0x00E00000) >> 21;
			Ro = (inst & 0x001F0000) >> 16;
			Rb = (inst & 0x00001F00) >> 8;
			Imm = (inst & 0x00FF0000) >> 16;
			GetBurstLen(tempstr, BurstLen);

			if (OP == 7) {
				if (IO) {
					sprintf(str, "%s R%u%s, R%u, %u, %s", f6_7_inst[LoadStore], Rx, bytenum[RxByteAddr], Rb, Imm, tempstr);
				} else {
					sprintf(str, "%s R%u%s, R%u, R%u%s, %s", f6_7_inst[LoadStore], Rx, bytenum[RxByteAddr], Rb, Ro, sis[RoSel], tempstr);
				}
			} else {  // OP==4
				if (IO) {
					sprintf(str, "%s R%u%s, C%u, %u, %s", f6_4_inst[LoadStore], Rx, bytenum[RxByteAddr], Rb, Imm, tempstr);
				} else {
					sprintf(str, "%s R%u%s, C%u, R%u%s, %s", f6_4_inst[LoadStore], Rx, bytenum[RxByteAddr], Rb, Ro, sis[RoSel], tempstr);
				}
			}
			break;

		default:
			sprintf(str, "UNKNOWN");
			break;
	}
}

