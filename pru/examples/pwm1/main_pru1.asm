;******************************************************************************
;* PRU C/C++ Codegen                                              Unix v2.1.2 *
;* Date/Time created: Fri Oct 14 13:14:29 2016                                *
;******************************************************************************
	.compiler_opts --abi=eabi --endian=little --hll_source=on --object_format=elf --silicon_version=3 --symdebug:dwarf --symdebug:dwarf_version=3 

$C$DW$CU	.dwtag  DW_TAG_compile_unit
	.dwattr $C$DW$CU, DW_AT_name("main_pru1.c")
	.dwattr $C$DW$CU, DW_AT_producer("TI PRU C/C++ Codegen Unix v2.1.2 Copyright (c) 2012-2015 Texas Instruments Incorporated")
	.dwattr $C$DW$CU, DW_AT_TI_version(0x01)
	.dwattr $C$DW$CU, DW_AT_comp_dir("/root/exercises/pru/examples/ebb")
	.global	__PRU_CREG_PRU_CFG

$C$DW$1	.dwtag  DW_TAG_subprogram, DW_AT_name("start")
	.dwattr $C$DW$1, DW_AT_TI_symbol_name("start")
	.dwattr $C$DW$1, DW_AT_declaration
	.dwattr $C$DW$1, DW_AT_external
	.dwattr $C$DW$1, DW_AT_decl_file("main_pru1.c")
	.dwattr $C$DW$1, DW_AT_decl_line(0x2d)
	.dwattr $C$DW$1, DW_AT_decl_column(0x0d)
	.weak	||CT_CFG||
||CT_CFG||:	.usect	".creg.PRU_CFG.noload.near",68,1
$C$DW$2	.dwtag  DW_TAG_variable, DW_AT_name("CT_CFG")
	.dwattr $C$DW$2, DW_AT_TI_symbol_name("CT_CFG")
	.dwattr $C$DW$2, DW_AT_location[DW_OP_addr ||CT_CFG||]
	.dwattr $C$DW$2, DW_AT_type(*$C$DW$T$98)
	.dwattr $C$DW$2, DW_AT_external
	.dwattr $C$DW$2, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$2, DW_AT_decl_line(0xf2)
	.dwattr $C$DW$2, DW_AT_decl_column(0x17)
	.global	||pru_remoteproc_ResourceTable||
	.sect	".resource_table:retain", RW
	.retain
	.align	1
	.elfsym	||pru_remoteproc_ResourceTable||,SYM_SIZE(20)
||pru_remoteproc_ResourceTable||:
	.bits	1,32			; pru_remoteproc_ResourceTable.base.ver @ 0
	.bits	0,32			; pru_remoteproc_ResourceTable.base.num @ 32
	.bits	0,32			; pru_remoteproc_ResourceTable.base.reserved[0] @ 64
	.bits	0,32			; pru_remoteproc_ResourceTable.base.reserved[1] @ 96
	.bits	0,32			; pru_remoteproc_ResourceTable.offset[0] @ 128

$C$DW$3	.dwtag  DW_TAG_variable, DW_AT_name("pru_remoteproc_ResourceTable")
	.dwattr $C$DW$3, DW_AT_TI_symbol_name("pru_remoteproc_ResourceTable")
	.dwattr $C$DW$3, DW_AT_location[DW_OP_addr ||pru_remoteproc_ResourceTable||]
	.dwattr $C$DW$3, DW_AT_type(*$C$DW$T$92)
	.dwattr $C$DW$3, DW_AT_external
	.dwattr $C$DW$3, DW_AT_decl_file("resource_table_pru1.h")
	.dwattr $C$DW$3, DW_AT_decl_line(0x40)
	.dwattr $C$DW$3, DW_AT_decl_column(0x1a)
;	optpru /tmp/05176WPFEjL /tmp/05176C6dcvm 
;	acpiapru -@/tmp/05176HlH4Ep 
	.sect	".text:main"
	.clink
	.global	||main||

$C$DW$4	.dwtag  DW_TAG_subprogram, DW_AT_name("main")
	.dwattr $C$DW$4, DW_AT_low_pc(||main||)
	.dwattr $C$DW$4, DW_AT_high_pc(0x00)
	.dwattr $C$DW$4, DW_AT_TI_symbol_name("main")
	.dwattr $C$DW$4, DW_AT_external
	.dwattr $C$DW$4, DW_AT_TI_begin_file("main_pru1.c")
	.dwattr $C$DW$4, DW_AT_TI_begin_line(0x2f)
	.dwattr $C$DW$4, DW_AT_TI_begin_column(0x06)
	.dwattr $C$DW$4, DW_AT_decl_file("main_pru1.c")
	.dwattr $C$DW$4, DW_AT_decl_line(0x2f)
	.dwattr $C$DW$4, DW_AT_decl_column(0x06)
	.dwattr $C$DW$4, DW_AT_TI_max_frame_size(0x02)
	.dwpsn	file "main_pru1.c",line 48,column 1,is_stmt,address ||main||,isa 0

	.dwfde $C$DW$CIE, ||main||
;----------------------------------------------------------------------
;  47 | void main(void)                                                        
;----------------------------------------------------------------------

;***************************************************************
;* FNAME: main                          FR SIZE:   2           *
;*                                                             *
;* FUNCTION ENVIRONMENT                                        *
;*                                                             *
;* FUNCTION PROPERTIES                                         *
;*                            0 Auto,  2 SOE     *
;***************************************************************

||main||:
;* --------------------------------------------------------------------------*
;* r0_0  assigned to $O$C1
;* r0_0  assigned to $O$C2
	.dwcfi	cfa_offset, 0
        SUB       r2, r2, 0x02          ; [ALU_PRU] 
	.dwcfi	cfa_offset, 2
	.dwpsn	file "main_pru1.c",line 50,column 2,is_stmt,isa 0
;----------------------------------------------------------------------
;  50 | CT_CFG.SYSCFG_bit.STANDBY_INIT = 0;                                    
;  52 | // Access PRU Shared RAM using Constant Table                          
;  53 | // C24 defaults to 0x00000000, we need to set bits 11:8 to 0x0200 in or
;     | der to access local data RAM                                           
;----------------------------------------------------------------------
        LBCO      &r0, __PRU_CREG_PRU_CFG, $CSBREL(||CT_CFG||+4), 4 ; [ALU_PRU] |50| CT_CFG
	.dwpsn	file "main_pru1.c",line 54,column 2,is_stmt,isa 0
;----------------------------------------------------------------------
;  54 | PRU1_CTRL.CTBIR0_bit.C24_BLK_IDX = 0x2;                                
;----------------------------------------------------------------------
        LDI32     r1, 0xffffff00        ; [ALU_PRU] |54| 
        SBBO      &r3.b2, r2, 0, 2      ; [ALU_PRU] 
	.dwcfi	save_reg_to_mem, 14, -2
	.dwcfi	save_reg_to_mem, 15, -1
	.dwpsn	file "main_pru1.c",line 50,column 2,is_stmt,isa 0
        CLR       r0, r0, 0x00000004    ; [ALU_PRU] |50| 
        SBCO      &r0, __PRU_CREG_PRU_CFG, $CSBREL(||CT_CFG||+4), 4 ; [ALU_PRU] |50| CT_CFG
	.dwpsn	file "main_pru1.c",line 54,column 2,is_stmt,isa 0
;----------------------------------------------------------------------
;  55 | // C28 defaults to 0x00000000, we need to set bits 23:8 to 0x0100 in or
;     | der to have it point to 0x00010000,                                    
;  56 | //              to access SHARED RAM                                   
;----------------------------------------------------------------------
        LDI32     r0, 0x00024020        ; [ALU_PRU] |54| $O$C2
        LBBO      &r14, r0, 0, 4        ; [ALU_PRU] |54| $O$C2
        AND       r1, r14, r1           ; [ALU_PRU] |54| 
        SET       r1, r1, 0x00000001    ; [ALU_PRU] |54| 
        SBBO      &r1, r0, 0, 4         ; [ALU_PRU] |54| $O$C2
	.dwpsn	file "main_pru1.c",line 57,column 2,is_stmt,isa 0
;----------------------------------------------------------------------
;  57 | PRU1_CTRL.CTPPR0_bit.C28_BLK_POINTER = 0x0100;                         
;----------------------------------------------------------------------
        LDI32     r1, 0xffff0000        ; [ALU_PRU] |57| 
        ADD       r0, r0, 0x08          ; [ALU_PRU] |57| $O$C1,$O$C2
        LBBO      &r14, r0, 0, 4        ; [ALU_PRU] |57| $O$C1
        AND       r1, r14, r1           ; [ALU_PRU] |57| 
        SET       r1, r1, 0x00000008    ; [ALU_PRU] |57| 
        SBBO      &r1, r0, 0, 4         ; [ALU_PRU] |57| $O$C1
	.dwpsn	file "main_pru1.c",line 59,column 2,is_stmt,isa 0
;----------------------------------------------------------------------
;  59 | start();                                                               
;----------------------------------------------------------------------
$C$DW$5	.dwtag  DW_TAG_TI_branch
	.dwattr $C$DW$5, DW_AT_low_pc(0x00)
	.dwattr $C$DW$5, DW_AT_name("start")
	.dwattr $C$DW$5, DW_AT_TI_call
        JAL       r3.w2, ||start||      ; [ALU_PRU] |59| start
        LBBO      &r3.b2, r2, 0, 2      ; [ALU_PRU] 
	.dwcfi	restore_reg, 14
	.dwcfi	restore_reg, 15
        ADD       r2, r2, 0x02          ; [ALU_PRU] 
	.dwcfi	cfa_offset, 0
$C$DW$6	.dwtag  DW_TAG_TI_branch
	.dwattr $C$DW$6, DW_AT_low_pc(0x00)
	.dwattr $C$DW$6, DW_AT_TI_return
        JMP       r3.w2                 ; [ALU_PRU] 
	.dwattr $C$DW$4, DW_AT_TI_end_file("main_pru1.c")
	.dwattr $C$DW$4, DW_AT_TI_end_line(0x3c)
	.dwattr $C$DW$4, DW_AT_TI_end_column(0x01)
	.dwendentry
	.dwendtag $C$DW$4

;*****************************************************************************
;* UNDEFINED EXTERNAL REFERENCES                                             *
;*****************************************************************************
	.global	||start||

;******************************************************************************
;* TYPE INFORMATION                                                           *
;******************************************************************************

$C$DW$T$19	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$19, DW_AT_byte_size(0x04)
$C$DW$7	.dwtag  DW_TAG_member
	.dwattr $C$DW$7, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$7, DW_AT_name("REVID")
	.dwattr $C$DW$7, DW_AT_TI_symbol_name("REVID")
	.dwattr $C$DW$7, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x20)
	.dwattr $C$DW$7, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$7, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$7, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$7, DW_AT_decl_line(0x2d)
	.dwattr $C$DW$7, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$19

	.dwattr $C$DW$T$19, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$19, DW_AT_decl_line(0x2c)
	.dwattr $C$DW$T$19, DW_AT_decl_column(0x13)
$C$DW$T$48	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$48, DW_AT_type(*$C$DW$T$19)

$C$DW$T$20	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$20, DW_AT_byte_size(0x04)
$C$DW$8	.dwtag  DW_TAG_member
	.dwattr $C$DW$8, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$8, DW_AT_name("IDLE_MODE")
	.dwattr $C$DW$8, DW_AT_TI_symbol_name("IDLE_MODE")
	.dwattr $C$DW$8, DW_AT_bit_offset(0x1e), DW_AT_bit_size(0x02)
	.dwattr $C$DW$8, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$8, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$8, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$8, DW_AT_decl_line(0x37)
	.dwattr $C$DW$8, DW_AT_decl_column(0x0d)
$C$DW$9	.dwtag  DW_TAG_member
	.dwattr $C$DW$9, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$9, DW_AT_name("STANDBY_MODE")
	.dwattr $C$DW$9, DW_AT_TI_symbol_name("STANDBY_MODE")
	.dwattr $C$DW$9, DW_AT_bit_offset(0x1c), DW_AT_bit_size(0x02)
	.dwattr $C$DW$9, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$9, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$9, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$9, DW_AT_decl_line(0x38)
	.dwattr $C$DW$9, DW_AT_decl_column(0x0d)
$C$DW$10	.dwtag  DW_TAG_member
	.dwattr $C$DW$10, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$10, DW_AT_name("STANDBY_INIT")
	.dwattr $C$DW$10, DW_AT_TI_symbol_name("STANDBY_INIT")
	.dwattr $C$DW$10, DW_AT_bit_offset(0x1b), DW_AT_bit_size(0x01)
	.dwattr $C$DW$10, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$10, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$10, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$10, DW_AT_decl_line(0x39)
	.dwattr $C$DW$10, DW_AT_decl_column(0x0d)
$C$DW$11	.dwtag  DW_TAG_member
	.dwattr $C$DW$11, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$11, DW_AT_name("SUB_MWAIT")
	.dwattr $C$DW$11, DW_AT_TI_symbol_name("SUB_MWAIT")
	.dwattr $C$DW$11, DW_AT_bit_offset(0x1a), DW_AT_bit_size(0x01)
	.dwattr $C$DW$11, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$11, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$11, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$11, DW_AT_decl_line(0x3a)
	.dwattr $C$DW$11, DW_AT_decl_column(0x0d)
$C$DW$12	.dwtag  DW_TAG_member
	.dwattr $C$DW$12, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$12, DW_AT_name("rsvd6")
	.dwattr $C$DW$12, DW_AT_TI_symbol_name("rsvd6")
	.dwattr $C$DW$12, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x1a)
	.dwattr $C$DW$12, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$12, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$12, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$12, DW_AT_decl_line(0x3b)
	.dwattr $C$DW$12, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$20

	.dwattr $C$DW$T$20, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$20, DW_AT_decl_line(0x36)
	.dwattr $C$DW$T$20, DW_AT_decl_column(0x13)
$C$DW$T$50	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$50, DW_AT_type(*$C$DW$T$20)

$C$DW$T$21	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$21, DW_AT_byte_size(0x04)
$C$DW$13	.dwtag  DW_TAG_member
	.dwattr $C$DW$13, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$13, DW_AT_name("PRU0_GPI_MODE")
	.dwattr $C$DW$13, DW_AT_TI_symbol_name("PRU0_GPI_MODE")
	.dwattr $C$DW$13, DW_AT_bit_offset(0x1e), DW_AT_bit_size(0x02)
	.dwattr $C$DW$13, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$13, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$13, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$13, DW_AT_decl_line(0x45)
	.dwattr $C$DW$13, DW_AT_decl_column(0x0d)
$C$DW$14	.dwtag  DW_TAG_member
	.dwattr $C$DW$14, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$14, DW_AT_name("PRU0_GPI_CLK_MODE")
	.dwattr $C$DW$14, DW_AT_TI_symbol_name("PRU0_GPI_CLK_MODE")
	.dwattr $C$DW$14, DW_AT_bit_offset(0x1d), DW_AT_bit_size(0x01)
	.dwattr $C$DW$14, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$14, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$14, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$14, DW_AT_decl_line(0x46)
	.dwattr $C$DW$14, DW_AT_decl_column(0x0d)
$C$DW$15	.dwtag  DW_TAG_member
	.dwattr $C$DW$15, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$15, DW_AT_name("PRU0_GPI_DIV0")
	.dwattr $C$DW$15, DW_AT_TI_symbol_name("PRU0_GPI_DIV0")
	.dwattr $C$DW$15, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x05)
	.dwattr $C$DW$15, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$15, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$15, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$15, DW_AT_decl_line(0x47)
	.dwattr $C$DW$15, DW_AT_decl_column(0x0d)
$C$DW$16	.dwtag  DW_TAG_member
	.dwattr $C$DW$16, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$16, DW_AT_name("PRU0_GPI_DIV1")
	.dwattr $C$DW$16, DW_AT_TI_symbol_name("PRU0_GPI_DIV1")
	.dwattr $C$DW$16, DW_AT_bit_offset(0x13), DW_AT_bit_size(0x05)
	.dwattr $C$DW$16, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$16, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$16, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$16, DW_AT_decl_line(0x48)
	.dwattr $C$DW$16, DW_AT_decl_column(0x0d)
$C$DW$17	.dwtag  DW_TAG_member
	.dwattr $C$DW$17, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$17, DW_AT_name("PRU0_GPI_SB")
	.dwattr $C$DW$17, DW_AT_TI_symbol_name("PRU0_GPI_SB")
	.dwattr $C$DW$17, DW_AT_bit_offset(0x12), DW_AT_bit_size(0x01)
	.dwattr $C$DW$17, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$17, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$17, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$17, DW_AT_decl_line(0x49)
	.dwattr $C$DW$17, DW_AT_decl_column(0x0d)
$C$DW$18	.dwtag  DW_TAG_member
	.dwattr $C$DW$18, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$18, DW_AT_name("PRU0_GPO_MODE")
	.dwattr $C$DW$18, DW_AT_TI_symbol_name("PRU0_GPO_MODE")
	.dwattr $C$DW$18, DW_AT_bit_offset(0x11), DW_AT_bit_size(0x01)
	.dwattr $C$DW$18, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$18, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$18, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$18, DW_AT_decl_line(0x4a)
	.dwattr $C$DW$18, DW_AT_decl_column(0x0d)
$C$DW$19	.dwtag  DW_TAG_member
	.dwattr $C$DW$19, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$19, DW_AT_name("PRU0_GPO_DIV0")
	.dwattr $C$DW$19, DW_AT_TI_symbol_name("PRU0_GPO_DIV0")
	.dwattr $C$DW$19, DW_AT_bit_offset(0x0c), DW_AT_bit_size(0x05)
	.dwattr $C$DW$19, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$19, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$19, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$19, DW_AT_decl_line(0x4b)
	.dwattr $C$DW$19, DW_AT_decl_column(0x0d)
$C$DW$20	.dwtag  DW_TAG_member
	.dwattr $C$DW$20, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$20, DW_AT_name("PRU0_GPO_DIV1")
	.dwattr $C$DW$20, DW_AT_TI_symbol_name("PRU0_GPO_DIV1")
	.dwattr $C$DW$20, DW_AT_bit_offset(0x07), DW_AT_bit_size(0x05)
	.dwattr $C$DW$20, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$20, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$20, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$20, DW_AT_decl_line(0x4c)
	.dwattr $C$DW$20, DW_AT_decl_column(0x0d)
$C$DW$21	.dwtag  DW_TAG_member
	.dwattr $C$DW$21, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$21, DW_AT_name("PRU0_GPO_SH_SEL")
	.dwattr $C$DW$21, DW_AT_TI_symbol_name("PRU0_GPO_SH_SEL")
	.dwattr $C$DW$21, DW_AT_bit_offset(0x06), DW_AT_bit_size(0x01)
	.dwattr $C$DW$21, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$21, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$21, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$21, DW_AT_decl_line(0x4d)
	.dwattr $C$DW$21, DW_AT_decl_column(0x0d)
$C$DW$22	.dwtag  DW_TAG_member
	.dwattr $C$DW$22, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$22, DW_AT_name("rsvd26")
	.dwattr $C$DW$22, DW_AT_TI_symbol_name("rsvd26")
	.dwattr $C$DW$22, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x06)
	.dwattr $C$DW$22, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$22, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$22, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$22, DW_AT_decl_line(0x4e)
	.dwattr $C$DW$22, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$21

	.dwattr $C$DW$T$21, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$21, DW_AT_decl_line(0x44)
	.dwattr $C$DW$T$21, DW_AT_decl_column(0x13)
$C$DW$T$52	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$52, DW_AT_type(*$C$DW$T$21)

$C$DW$T$22	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$22, DW_AT_byte_size(0x04)
$C$DW$23	.dwtag  DW_TAG_member
	.dwattr $C$DW$23, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$23, DW_AT_name("PRU1_GPI_MODE")
	.dwattr $C$DW$23, DW_AT_TI_symbol_name("PRU1_GPI_MODE")
	.dwattr $C$DW$23, DW_AT_bit_offset(0x1e), DW_AT_bit_size(0x02)
	.dwattr $C$DW$23, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$23, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$23, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$23, DW_AT_decl_line(0x58)
	.dwattr $C$DW$23, DW_AT_decl_column(0x0d)
$C$DW$24	.dwtag  DW_TAG_member
	.dwattr $C$DW$24, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$24, DW_AT_name("PRU1_GPI_CLK_MODE")
	.dwattr $C$DW$24, DW_AT_TI_symbol_name("PRU1_GPI_CLK_MODE")
	.dwattr $C$DW$24, DW_AT_bit_offset(0x1d), DW_AT_bit_size(0x01)
	.dwattr $C$DW$24, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$24, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$24, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$24, DW_AT_decl_line(0x59)
	.dwattr $C$DW$24, DW_AT_decl_column(0x0d)
$C$DW$25	.dwtag  DW_TAG_member
	.dwattr $C$DW$25, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$25, DW_AT_name("PRU1_GPI_DIV0")
	.dwattr $C$DW$25, DW_AT_TI_symbol_name("PRU1_GPI_DIV0")
	.dwattr $C$DW$25, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x05)
	.dwattr $C$DW$25, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$25, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$25, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$25, DW_AT_decl_line(0x5a)
	.dwattr $C$DW$25, DW_AT_decl_column(0x0d)
$C$DW$26	.dwtag  DW_TAG_member
	.dwattr $C$DW$26, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$26, DW_AT_name("PRU1_GPI_DIV1")
	.dwattr $C$DW$26, DW_AT_TI_symbol_name("PRU1_GPI_DIV1")
	.dwattr $C$DW$26, DW_AT_bit_offset(0x13), DW_AT_bit_size(0x05)
	.dwattr $C$DW$26, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$26, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$26, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$26, DW_AT_decl_line(0x5b)
	.dwattr $C$DW$26, DW_AT_decl_column(0x0d)
$C$DW$27	.dwtag  DW_TAG_member
	.dwattr $C$DW$27, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$27, DW_AT_name("PRU1_GPI_SB")
	.dwattr $C$DW$27, DW_AT_TI_symbol_name("PRU1_GPI_SB")
	.dwattr $C$DW$27, DW_AT_bit_offset(0x12), DW_AT_bit_size(0x01)
	.dwattr $C$DW$27, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$27, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$27, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$27, DW_AT_decl_line(0x5c)
	.dwattr $C$DW$27, DW_AT_decl_column(0x0d)
$C$DW$28	.dwtag  DW_TAG_member
	.dwattr $C$DW$28, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$28, DW_AT_name("PRU1_GPO_MODE")
	.dwattr $C$DW$28, DW_AT_TI_symbol_name("PRU1_GPO_MODE")
	.dwattr $C$DW$28, DW_AT_bit_offset(0x11), DW_AT_bit_size(0x01)
	.dwattr $C$DW$28, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$28, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$28, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$28, DW_AT_decl_line(0x5d)
	.dwattr $C$DW$28, DW_AT_decl_column(0x0d)
$C$DW$29	.dwtag  DW_TAG_member
	.dwattr $C$DW$29, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$29, DW_AT_name("PRU1_GPO_DIV0")
	.dwattr $C$DW$29, DW_AT_TI_symbol_name("PRU1_GPO_DIV0")
	.dwattr $C$DW$29, DW_AT_bit_offset(0x0c), DW_AT_bit_size(0x05)
	.dwattr $C$DW$29, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$29, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$29, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$29, DW_AT_decl_line(0x5e)
	.dwattr $C$DW$29, DW_AT_decl_column(0x0d)
$C$DW$30	.dwtag  DW_TAG_member
	.dwattr $C$DW$30, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$30, DW_AT_name("PRU1_GPO_DIV1")
	.dwattr $C$DW$30, DW_AT_TI_symbol_name("PRU1_GPO_DIV1")
	.dwattr $C$DW$30, DW_AT_bit_offset(0x07), DW_AT_bit_size(0x05)
	.dwattr $C$DW$30, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$30, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$30, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$30, DW_AT_decl_line(0x5f)
	.dwattr $C$DW$30, DW_AT_decl_column(0x0d)
$C$DW$31	.dwtag  DW_TAG_member
	.dwattr $C$DW$31, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$31, DW_AT_name("PRU1_GPO_SH_SEL")
	.dwattr $C$DW$31, DW_AT_TI_symbol_name("PRU1_GPO_SH_SEL")
	.dwattr $C$DW$31, DW_AT_bit_offset(0x06), DW_AT_bit_size(0x01)
	.dwattr $C$DW$31, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$31, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$31, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$31, DW_AT_decl_line(0x60)
	.dwattr $C$DW$31, DW_AT_decl_column(0x0d)
$C$DW$32	.dwtag  DW_TAG_member
	.dwattr $C$DW$32, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$32, DW_AT_name("rsvd26")
	.dwattr $C$DW$32, DW_AT_TI_symbol_name("rsvd26")
	.dwattr $C$DW$32, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x06)
	.dwattr $C$DW$32, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$32, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$32, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$32, DW_AT_decl_line(0x61)
	.dwattr $C$DW$32, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$22

	.dwattr $C$DW$T$22, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$22, DW_AT_decl_line(0x57)
	.dwattr $C$DW$T$22, DW_AT_decl_column(0x13)
$C$DW$T$54	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$54, DW_AT_type(*$C$DW$T$22)

$C$DW$T$23	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$23, DW_AT_byte_size(0x04)
$C$DW$33	.dwtag  DW_TAG_member
	.dwattr $C$DW$33, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$33, DW_AT_name("PRU0_CLK_STOP_REQ")
	.dwattr $C$DW$33, DW_AT_TI_symbol_name("PRU0_CLK_STOP_REQ")
	.dwattr $C$DW$33, DW_AT_bit_offset(0x1f), DW_AT_bit_size(0x01)
	.dwattr $C$DW$33, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$33, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$33, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$33, DW_AT_decl_line(0x6b)
	.dwattr $C$DW$33, DW_AT_decl_column(0x0d)
$C$DW$34	.dwtag  DW_TAG_member
	.dwattr $C$DW$34, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$34, DW_AT_name("PRU0_CLK_STOP_ACK")
	.dwattr $C$DW$34, DW_AT_TI_symbol_name("PRU0_CLK_STOP_ACK")
	.dwattr $C$DW$34, DW_AT_bit_offset(0x1e), DW_AT_bit_size(0x01)
	.dwattr $C$DW$34, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$34, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$34, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$34, DW_AT_decl_line(0x6c)
	.dwattr $C$DW$34, DW_AT_decl_column(0x0d)
$C$DW$35	.dwtag  DW_TAG_member
	.dwattr $C$DW$35, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$35, DW_AT_name("PRU0_CLK_EN")
	.dwattr $C$DW$35, DW_AT_TI_symbol_name("PRU0_CLK_EN")
	.dwattr $C$DW$35, DW_AT_bit_offset(0x1d), DW_AT_bit_size(0x01)
	.dwattr $C$DW$35, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$35, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$35, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$35, DW_AT_decl_line(0x6d)
	.dwattr $C$DW$35, DW_AT_decl_column(0x0d)
$C$DW$36	.dwtag  DW_TAG_member
	.dwattr $C$DW$36, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$36, DW_AT_name("PRU1_CLK_STOP_REQ")
	.dwattr $C$DW$36, DW_AT_TI_symbol_name("PRU1_CLK_STOP_REQ")
	.dwattr $C$DW$36, DW_AT_bit_offset(0x1c), DW_AT_bit_size(0x01)
	.dwattr $C$DW$36, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$36, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$36, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$36, DW_AT_decl_line(0x6e)
	.dwattr $C$DW$36, DW_AT_decl_column(0x0d)
$C$DW$37	.dwtag  DW_TAG_member
	.dwattr $C$DW$37, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$37, DW_AT_name("PRU1_CLK_STOP_ACK")
	.dwattr $C$DW$37, DW_AT_TI_symbol_name("PRU1_CLK_STOP_ACK")
	.dwattr $C$DW$37, DW_AT_bit_offset(0x1b), DW_AT_bit_size(0x01)
	.dwattr $C$DW$37, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$37, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$37, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$37, DW_AT_decl_line(0x6f)
	.dwattr $C$DW$37, DW_AT_decl_column(0x0d)
$C$DW$38	.dwtag  DW_TAG_member
	.dwattr $C$DW$38, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$38, DW_AT_name("PRU1_CLK_EN")
	.dwattr $C$DW$38, DW_AT_TI_symbol_name("PRU1_CLK_EN")
	.dwattr $C$DW$38, DW_AT_bit_offset(0x1a), DW_AT_bit_size(0x01)
	.dwattr $C$DW$38, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$38, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$38, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$38, DW_AT_decl_line(0x70)
	.dwattr $C$DW$38, DW_AT_decl_column(0x0d)
$C$DW$39	.dwtag  DW_TAG_member
	.dwattr $C$DW$39, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$39, DW_AT_name("INTC_CLK_STOP_REQ")
	.dwattr $C$DW$39, DW_AT_TI_symbol_name("INTC_CLK_STOP_REQ")
	.dwattr $C$DW$39, DW_AT_bit_offset(0x19), DW_AT_bit_size(0x01)
	.dwattr $C$DW$39, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$39, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$39, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$39, DW_AT_decl_line(0x71)
	.dwattr $C$DW$39, DW_AT_decl_column(0x0d)
$C$DW$40	.dwtag  DW_TAG_member
	.dwattr $C$DW$40, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$40, DW_AT_name("INTC_CLK_STOP_ACK")
	.dwattr $C$DW$40, DW_AT_TI_symbol_name("INTC_CLK_STOP_ACK")
	.dwattr $C$DW$40, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x01)
	.dwattr $C$DW$40, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$40, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$40, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$40, DW_AT_decl_line(0x72)
	.dwattr $C$DW$40, DW_AT_decl_column(0x0d)
$C$DW$41	.dwtag  DW_TAG_member
	.dwattr $C$DW$41, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$41, DW_AT_name("INTC_CLK_EN")
	.dwattr $C$DW$41, DW_AT_TI_symbol_name("INTC_CLK_EN")
	.dwattr $C$DW$41, DW_AT_bit_offset(0x17), DW_AT_bit_size(0x01)
	.dwattr $C$DW$41, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$41, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$41, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$41, DW_AT_decl_line(0x73)
	.dwattr $C$DW$41, DW_AT_decl_column(0x0d)
$C$DW$42	.dwtag  DW_TAG_member
	.dwattr $C$DW$42, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$42, DW_AT_name("UART_CLK_STOP_REQ")
	.dwattr $C$DW$42, DW_AT_TI_symbol_name("UART_CLK_STOP_REQ")
	.dwattr $C$DW$42, DW_AT_bit_offset(0x16), DW_AT_bit_size(0x01)
	.dwattr $C$DW$42, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$42, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$42, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$42, DW_AT_decl_line(0x74)
	.dwattr $C$DW$42, DW_AT_decl_column(0x0d)
$C$DW$43	.dwtag  DW_TAG_member
	.dwattr $C$DW$43, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$43, DW_AT_name("UART_CLK_STOP_ACK")
	.dwattr $C$DW$43, DW_AT_TI_symbol_name("UART_CLK_STOP_ACK")
	.dwattr $C$DW$43, DW_AT_bit_offset(0x15), DW_AT_bit_size(0x01)
	.dwattr $C$DW$43, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$43, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$43, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$43, DW_AT_decl_line(0x75)
	.dwattr $C$DW$43, DW_AT_decl_column(0x0d)
$C$DW$44	.dwtag  DW_TAG_member
	.dwattr $C$DW$44, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$44, DW_AT_name("UART_CLK_EN")
	.dwattr $C$DW$44, DW_AT_TI_symbol_name("UART_CLK_EN")
	.dwattr $C$DW$44, DW_AT_bit_offset(0x14), DW_AT_bit_size(0x01)
	.dwattr $C$DW$44, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$44, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$44, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$44, DW_AT_decl_line(0x76)
	.dwattr $C$DW$44, DW_AT_decl_column(0x0d)
$C$DW$45	.dwtag  DW_TAG_member
	.dwattr $C$DW$45, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$45, DW_AT_name("ECAP_CLK_STOP_REQ")
	.dwattr $C$DW$45, DW_AT_TI_symbol_name("ECAP_CLK_STOP_REQ")
	.dwattr $C$DW$45, DW_AT_bit_offset(0x13), DW_AT_bit_size(0x01)
	.dwattr $C$DW$45, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$45, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$45, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$45, DW_AT_decl_line(0x77)
	.dwattr $C$DW$45, DW_AT_decl_column(0x0d)
$C$DW$46	.dwtag  DW_TAG_member
	.dwattr $C$DW$46, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$46, DW_AT_name("ECAP_CLK_STOP_ACK")
	.dwattr $C$DW$46, DW_AT_TI_symbol_name("ECAP_CLK_STOP_ACK")
	.dwattr $C$DW$46, DW_AT_bit_offset(0x12), DW_AT_bit_size(0x01)
	.dwattr $C$DW$46, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$46, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$46, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$46, DW_AT_decl_line(0x78)
	.dwattr $C$DW$46, DW_AT_decl_column(0x0d)
$C$DW$47	.dwtag  DW_TAG_member
	.dwattr $C$DW$47, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$47, DW_AT_name("ECAP_CLK_EN")
	.dwattr $C$DW$47, DW_AT_TI_symbol_name("ECAP_CLK_EN")
	.dwattr $C$DW$47, DW_AT_bit_offset(0x11), DW_AT_bit_size(0x01)
	.dwattr $C$DW$47, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$47, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$47, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$47, DW_AT_decl_line(0x79)
	.dwattr $C$DW$47, DW_AT_decl_column(0x0d)
$C$DW$48	.dwtag  DW_TAG_member
	.dwattr $C$DW$48, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$48, DW_AT_name("IEP_CLK_STOP_REQ")
	.dwattr $C$DW$48, DW_AT_TI_symbol_name("IEP_CLK_STOP_REQ")
	.dwattr $C$DW$48, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x01)
	.dwattr $C$DW$48, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$48, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$48, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$48, DW_AT_decl_line(0x7a)
	.dwattr $C$DW$48, DW_AT_decl_column(0x0d)
$C$DW$49	.dwtag  DW_TAG_member
	.dwattr $C$DW$49, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$49, DW_AT_name("IEP_CLK_STOP_ACK")
	.dwattr $C$DW$49, DW_AT_TI_symbol_name("IEP_CLK_STOP_ACK")
	.dwattr $C$DW$49, DW_AT_bit_offset(0x0f), DW_AT_bit_size(0x01)
	.dwattr $C$DW$49, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$49, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$49, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$49, DW_AT_decl_line(0x7b)
	.dwattr $C$DW$49, DW_AT_decl_column(0x0d)
$C$DW$50	.dwtag  DW_TAG_member
	.dwattr $C$DW$50, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$50, DW_AT_name("IEP_CLK_EN")
	.dwattr $C$DW$50, DW_AT_TI_symbol_name("IEP_CLK_EN")
	.dwattr $C$DW$50, DW_AT_bit_offset(0x0e), DW_AT_bit_size(0x01)
	.dwattr $C$DW$50, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$50, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$50, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$50, DW_AT_decl_line(0x7c)
	.dwattr $C$DW$50, DW_AT_decl_column(0x0d)
$C$DW$51	.dwtag  DW_TAG_member
	.dwattr $C$DW$51, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$51, DW_AT_name("rsvd18")
	.dwattr $C$DW$51, DW_AT_TI_symbol_name("rsvd18")
	.dwattr $C$DW$51, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x0e)
	.dwattr $C$DW$51, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$51, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$51, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$51, DW_AT_decl_line(0x7d)
	.dwattr $C$DW$51, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$23

	.dwattr $C$DW$T$23, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$23, DW_AT_decl_line(0x6a)
	.dwattr $C$DW$T$23, DW_AT_decl_column(0x13)
$C$DW$T$56	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$56, DW_AT_type(*$C$DW$T$23)

$C$DW$T$24	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$24, DW_AT_byte_size(0x04)
$C$DW$52	.dwtag  DW_TAG_member
	.dwattr $C$DW$52, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$52, DW_AT_name("PRU0_IMEM_PE_RAW")
	.dwattr $C$DW$52, DW_AT_TI_symbol_name("PRU0_IMEM_PE_RAW")
	.dwattr $C$DW$52, DW_AT_bit_offset(0x1c), DW_AT_bit_size(0x04)
	.dwattr $C$DW$52, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$52, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$52, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$52, DW_AT_decl_line(0x87)
	.dwattr $C$DW$52, DW_AT_decl_column(0x0d)
$C$DW$53	.dwtag  DW_TAG_member
	.dwattr $C$DW$53, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$53, DW_AT_name("PRU0_DMEM_PE_RAW")
	.dwattr $C$DW$53, DW_AT_TI_symbol_name("PRU0_DMEM_PE_RAW")
	.dwattr $C$DW$53, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x04)
	.dwattr $C$DW$53, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$53, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$53, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$53, DW_AT_decl_line(0x88)
	.dwattr $C$DW$53, DW_AT_decl_column(0x0d)
$C$DW$54	.dwtag  DW_TAG_member
	.dwattr $C$DW$54, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$54, DW_AT_name("PRU1_IMEM_PE_RAW")
	.dwattr $C$DW$54, DW_AT_TI_symbol_name("PRU1_IMEM_PE_RAW")
	.dwattr $C$DW$54, DW_AT_bit_offset(0x14), DW_AT_bit_size(0x04)
	.dwattr $C$DW$54, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$54, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$54, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$54, DW_AT_decl_line(0x89)
	.dwattr $C$DW$54, DW_AT_decl_column(0x0d)
$C$DW$55	.dwtag  DW_TAG_member
	.dwattr $C$DW$55, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$55, DW_AT_name("PRU1_DMEM_PE_RAW")
	.dwattr $C$DW$55, DW_AT_TI_symbol_name("PRU1_DMEM_PE_RAW")
	.dwattr $C$DW$55, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x04)
	.dwattr $C$DW$55, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$55, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$55, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$55, DW_AT_decl_line(0x8a)
	.dwattr $C$DW$55, DW_AT_decl_column(0x0d)
$C$DW$56	.dwtag  DW_TAG_member
	.dwattr $C$DW$56, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$56, DW_AT_name("RAM_PE_RAW")
	.dwattr $C$DW$56, DW_AT_TI_symbol_name("RAM_PE_RAW")
	.dwattr $C$DW$56, DW_AT_bit_offset(0x0c), DW_AT_bit_size(0x04)
	.dwattr $C$DW$56, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$56, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$56, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$56, DW_AT_decl_line(0x8b)
	.dwattr $C$DW$56, DW_AT_decl_column(0x0d)
$C$DW$57	.dwtag  DW_TAG_member
	.dwattr $C$DW$57, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$57, DW_AT_name("rsvd20")
	.dwattr $C$DW$57, DW_AT_TI_symbol_name("rsvd20")
	.dwattr $C$DW$57, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x0c)
	.dwattr $C$DW$57, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$57, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$57, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$57, DW_AT_decl_line(0x8c)
	.dwattr $C$DW$57, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$24

	.dwattr $C$DW$T$24, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$24, DW_AT_decl_line(0x86)
	.dwattr $C$DW$T$24, DW_AT_decl_column(0x14)
$C$DW$T$58	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$58, DW_AT_type(*$C$DW$T$24)

$C$DW$T$25	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$25, DW_AT_byte_size(0x04)
$C$DW$58	.dwtag  DW_TAG_member
	.dwattr $C$DW$58, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$58, DW_AT_name("PRU0_IMEM_PE")
	.dwattr $C$DW$58, DW_AT_TI_symbol_name("PRU0_IMEM_PE")
	.dwattr $C$DW$58, DW_AT_bit_offset(0x1c), DW_AT_bit_size(0x04)
	.dwattr $C$DW$58, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$58, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$58, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$58, DW_AT_decl_line(0x96)
	.dwattr $C$DW$58, DW_AT_decl_column(0x0d)
$C$DW$59	.dwtag  DW_TAG_member
	.dwattr $C$DW$59, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$59, DW_AT_name("PRU0_DMEM_PE")
	.dwattr $C$DW$59, DW_AT_TI_symbol_name("PRU0_DMEM_PE")
	.dwattr $C$DW$59, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x04)
	.dwattr $C$DW$59, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$59, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$59, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$59, DW_AT_decl_line(0x97)
	.dwattr $C$DW$59, DW_AT_decl_column(0x0d)
$C$DW$60	.dwtag  DW_TAG_member
	.dwattr $C$DW$60, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$60, DW_AT_name("PRU1_IMEM_PE")
	.dwattr $C$DW$60, DW_AT_TI_symbol_name("PRU1_IMEM_PE")
	.dwattr $C$DW$60, DW_AT_bit_offset(0x14), DW_AT_bit_size(0x04)
	.dwattr $C$DW$60, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$60, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$60, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$60, DW_AT_decl_line(0x98)
	.dwattr $C$DW$60, DW_AT_decl_column(0x0d)
$C$DW$61	.dwtag  DW_TAG_member
	.dwattr $C$DW$61, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$61, DW_AT_name("PRU1_DMEM_PE")
	.dwattr $C$DW$61, DW_AT_TI_symbol_name("PRU1_DMEM_PE")
	.dwattr $C$DW$61, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x04)
	.dwattr $C$DW$61, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$61, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$61, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$61, DW_AT_decl_line(0x99)
	.dwattr $C$DW$61, DW_AT_decl_column(0x0d)
$C$DW$62	.dwtag  DW_TAG_member
	.dwattr $C$DW$62, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$62, DW_AT_name("RAM_PE")
	.dwattr $C$DW$62, DW_AT_TI_symbol_name("RAM_PE")
	.dwattr $C$DW$62, DW_AT_bit_offset(0x0c), DW_AT_bit_size(0x04)
	.dwattr $C$DW$62, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$62, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$62, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$62, DW_AT_decl_line(0x9a)
	.dwattr $C$DW$62, DW_AT_decl_column(0x0d)
$C$DW$63	.dwtag  DW_TAG_member
	.dwattr $C$DW$63, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$63, DW_AT_name("rsvd20")
	.dwattr $C$DW$63, DW_AT_TI_symbol_name("rsvd20")
	.dwattr $C$DW$63, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x0c)
	.dwattr $C$DW$63, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$63, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$63, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$63, DW_AT_decl_line(0x9b)
	.dwattr $C$DW$63, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$25

	.dwattr $C$DW$T$25, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$25, DW_AT_decl_line(0x95)
	.dwattr $C$DW$T$25, DW_AT_decl_column(0x14)
$C$DW$T$60	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$60, DW_AT_type(*$C$DW$T$25)

$C$DW$T$26	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$26, DW_AT_byte_size(0x04)
$C$DW$64	.dwtag  DW_TAG_member
	.dwattr $C$DW$64, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$64, DW_AT_name("PRU0_IMEM_PE_SET")
	.dwattr $C$DW$64, DW_AT_TI_symbol_name("PRU0_IMEM_PE_SET")
	.dwattr $C$DW$64, DW_AT_bit_offset(0x1c), DW_AT_bit_size(0x04)
	.dwattr $C$DW$64, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$64, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$64, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$64, DW_AT_decl_line(0xa4)
	.dwattr $C$DW$64, DW_AT_decl_column(0x0d)
$C$DW$65	.dwtag  DW_TAG_member
	.dwattr $C$DW$65, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$65, DW_AT_name("PRU0_DMEM_PE_SET")
	.dwattr $C$DW$65, DW_AT_TI_symbol_name("PRU0_DMEM_PE_SET")
	.dwattr $C$DW$65, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x04)
	.dwattr $C$DW$65, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$65, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$65, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$65, DW_AT_decl_line(0xa5)
	.dwattr $C$DW$65, DW_AT_decl_column(0x0d)
$C$DW$66	.dwtag  DW_TAG_member
	.dwattr $C$DW$66, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$66, DW_AT_name("PRU1_IMEM_PE_SET")
	.dwattr $C$DW$66, DW_AT_TI_symbol_name("PRU1_IMEM_PE_SET")
	.dwattr $C$DW$66, DW_AT_bit_offset(0x14), DW_AT_bit_size(0x04)
	.dwattr $C$DW$66, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$66, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$66, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$66, DW_AT_decl_line(0xa6)
	.dwattr $C$DW$66, DW_AT_decl_column(0x0d)
$C$DW$67	.dwtag  DW_TAG_member
	.dwattr $C$DW$67, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$67, DW_AT_name("PRU1_DMEM_PE_SET")
	.dwattr $C$DW$67, DW_AT_TI_symbol_name("PRU1_DMEM_PE_SET")
	.dwattr $C$DW$67, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x04)
	.dwattr $C$DW$67, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$67, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$67, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$67, DW_AT_decl_line(0xa7)
	.dwattr $C$DW$67, DW_AT_decl_column(0x0d)
$C$DW$68	.dwtag  DW_TAG_member
	.dwattr $C$DW$68, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$68, DW_AT_name("RAM_PE_SET")
	.dwattr $C$DW$68, DW_AT_TI_symbol_name("RAM_PE_SET")
	.dwattr $C$DW$68, DW_AT_bit_offset(0x0c), DW_AT_bit_size(0x04)
	.dwattr $C$DW$68, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$68, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$68, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$68, DW_AT_decl_line(0xa8)
	.dwattr $C$DW$68, DW_AT_decl_column(0x0d)
$C$DW$69	.dwtag  DW_TAG_member
	.dwattr $C$DW$69, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$69, DW_AT_name("rsvd20")
	.dwattr $C$DW$69, DW_AT_TI_symbol_name("rsvd20")
	.dwattr $C$DW$69, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x0c)
	.dwattr $C$DW$69, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$69, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$69, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$69, DW_AT_decl_line(0xa9)
	.dwattr $C$DW$69, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$26

	.dwattr $C$DW$T$26, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$26, DW_AT_decl_line(0xa3)
	.dwattr $C$DW$T$26, DW_AT_decl_column(0x13)
$C$DW$T$62	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$62, DW_AT_type(*$C$DW$T$26)

$C$DW$T$27	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$27, DW_AT_byte_size(0x04)
$C$DW$70	.dwtag  DW_TAG_member
	.dwattr $C$DW$70, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$70, DW_AT_name("PRU0_IMEM_PE_CLR")
	.dwattr $C$DW$70, DW_AT_TI_symbol_name("PRU0_IMEM_PE_CLR")
	.dwattr $C$DW$70, DW_AT_bit_offset(0x1c), DW_AT_bit_size(0x04)
	.dwattr $C$DW$70, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$70, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$70, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$70, DW_AT_decl_line(0xb3)
	.dwattr $C$DW$70, DW_AT_decl_column(0x0d)
$C$DW$71	.dwtag  DW_TAG_member
	.dwattr $C$DW$71, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$71, DW_AT_name("PRU0_DMEM_PE_CLR")
	.dwattr $C$DW$71, DW_AT_TI_symbol_name("PRU0_DMEM_PE_CLR")
	.dwattr $C$DW$71, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x04)
	.dwattr $C$DW$71, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$71, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$71, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$71, DW_AT_decl_line(0xb4)
	.dwattr $C$DW$71, DW_AT_decl_column(0x0d)
$C$DW$72	.dwtag  DW_TAG_member
	.dwattr $C$DW$72, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$72, DW_AT_name("PRU1_IMEM_PE_CLR")
	.dwattr $C$DW$72, DW_AT_TI_symbol_name("PRU1_IMEM_PE_CLR")
	.dwattr $C$DW$72, DW_AT_bit_offset(0x14), DW_AT_bit_size(0x04)
	.dwattr $C$DW$72, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$72, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$72, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$72, DW_AT_decl_line(0xb5)
	.dwattr $C$DW$72, DW_AT_decl_column(0x0d)
$C$DW$73	.dwtag  DW_TAG_member
	.dwattr $C$DW$73, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$73, DW_AT_name("PRU1_DMEM_PE_CLR")
	.dwattr $C$DW$73, DW_AT_TI_symbol_name("PRU1_DMEM_PE_CLR")
	.dwattr $C$DW$73, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x04)
	.dwattr $C$DW$73, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$73, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$73, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$73, DW_AT_decl_line(0xb6)
	.dwattr $C$DW$73, DW_AT_decl_column(0x0d)
$C$DW$74	.dwtag  DW_TAG_member
	.dwattr $C$DW$74, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$74, DW_AT_name("rsvd16")
	.dwattr $C$DW$74, DW_AT_TI_symbol_name("rsvd16")
	.dwattr $C$DW$74, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x10)
	.dwattr $C$DW$74, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$74, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$74, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$74, DW_AT_decl_line(0xb7)
	.dwattr $C$DW$74, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$27

	.dwattr $C$DW$T$27, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$27, DW_AT_decl_line(0xb2)
	.dwattr $C$DW$T$27, DW_AT_decl_column(0x13)
$C$DW$T$64	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$64, DW_AT_type(*$C$DW$T$27)

$C$DW$T$28	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$28, DW_AT_byte_size(0x04)
$C$DW$75	.dwtag  DW_TAG_member
	.dwattr $C$DW$75, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$75, DW_AT_name("PMAO_PRU0")
	.dwattr $C$DW$75, DW_AT_TI_symbol_name("PMAO_PRU0")
	.dwattr $C$DW$75, DW_AT_bit_offset(0x1f), DW_AT_bit_size(0x01)
	.dwattr $C$DW$75, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$75, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$75, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$75, DW_AT_decl_line(0xc4)
	.dwattr $C$DW$75, DW_AT_decl_column(0x0d)
$C$DW$76	.dwtag  DW_TAG_member
	.dwattr $C$DW$76, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$76, DW_AT_name("PMAO_PRU1")
	.dwattr $C$DW$76, DW_AT_TI_symbol_name("PMAO_PRU1")
	.dwattr $C$DW$76, DW_AT_bit_offset(0x1e), DW_AT_bit_size(0x01)
	.dwattr $C$DW$76, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$76, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$76, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$76, DW_AT_decl_line(0xc5)
	.dwattr $C$DW$76, DW_AT_decl_column(0x0d)
$C$DW$77	.dwtag  DW_TAG_member
	.dwattr $C$DW$77, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$77, DW_AT_name("rsvd2")
	.dwattr $C$DW$77, DW_AT_TI_symbol_name("rsvd2")
	.dwattr $C$DW$77, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x1e)
	.dwattr $C$DW$77, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$77, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$77, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$77, DW_AT_decl_line(0xc6)
	.dwattr $C$DW$77, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$28

	.dwattr $C$DW$T$28, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$28, DW_AT_decl_line(0xc3)
	.dwattr $C$DW$T$28, DW_AT_decl_column(0x13)
$C$DW$T$66	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$66, DW_AT_type(*$C$DW$T$28)

$C$DW$T$29	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$29, DW_AT_byte_size(0x04)
$C$DW$78	.dwtag  DW_TAG_member
	.dwattr $C$DW$78, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$78, DW_AT_name("OCP_EN")
	.dwattr $C$DW$78, DW_AT_TI_symbol_name("OCP_EN")
	.dwattr $C$DW$78, DW_AT_bit_offset(0x1f), DW_AT_bit_size(0x01)
	.dwattr $C$DW$78, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$78, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$78, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$78, DW_AT_decl_line(0xd3)
	.dwattr $C$DW$78, DW_AT_decl_column(0x0d)
$C$DW$79	.dwtag  DW_TAG_member
	.dwattr $C$DW$79, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$79, DW_AT_name("rsvd1")
	.dwattr $C$DW$79, DW_AT_TI_symbol_name("rsvd1")
	.dwattr $C$DW$79, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x1f)
	.dwattr $C$DW$79, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$79, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$79, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$79, DW_AT_decl_line(0xd4)
	.dwattr $C$DW$79, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$29

	.dwattr $C$DW$T$29, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$29, DW_AT_decl_line(0xd2)
	.dwattr $C$DW$T$29, DW_AT_decl_column(0x13)
$C$DW$T$68	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$68, DW_AT_type(*$C$DW$T$29)

$C$DW$T$30	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$30, DW_AT_byte_size(0x04)
$C$DW$80	.dwtag  DW_TAG_member
	.dwattr $C$DW$80, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$80, DW_AT_name("PRU1_PAD_HP_EN")
	.dwattr $C$DW$80, DW_AT_TI_symbol_name("PRU1_PAD_HP_EN")
	.dwattr $C$DW$80, DW_AT_bit_offset(0x1f), DW_AT_bit_size(0x01)
	.dwattr $C$DW$80, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$80, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$80, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$80, DW_AT_decl_line(0xde)
	.dwattr $C$DW$80, DW_AT_decl_column(0x0d)
$C$DW$81	.dwtag  DW_TAG_member
	.dwattr $C$DW$81, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$81, DW_AT_name("XFR_SHIFT_EN")
	.dwattr $C$DW$81, DW_AT_TI_symbol_name("XFR_SHIFT_EN")
	.dwattr $C$DW$81, DW_AT_bit_offset(0x1e), DW_AT_bit_size(0x01)
	.dwattr $C$DW$81, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$81, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$81, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$81, DW_AT_decl_line(0xdf)
	.dwattr $C$DW$81, DW_AT_decl_column(0x0d)
$C$DW$82	.dwtag  DW_TAG_member
	.dwattr $C$DW$82, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$82, DW_AT_name("rsvd2")
	.dwattr $C$DW$82, DW_AT_TI_symbol_name("rsvd2")
	.dwattr $C$DW$82, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x1e)
	.dwattr $C$DW$82, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$82, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$82, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$82, DW_AT_decl_line(0xe0)
	.dwattr $C$DW$82, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$30

	.dwattr $C$DW$T$30, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$30, DW_AT_decl_line(0xdd)
	.dwattr $C$DW$T$30, DW_AT_decl_column(0x13)
$C$DW$T$70	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$70, DW_AT_type(*$C$DW$T$30)

$C$DW$T$31	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$31, DW_AT_byte_size(0x04)
$C$DW$83	.dwtag  DW_TAG_member
	.dwattr $C$DW$83, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$83, DW_AT_name("PIN_MUX_SEL")
	.dwattr $C$DW$83, DW_AT_TI_symbol_name("PIN_MUX_SEL")
	.dwattr $C$DW$83, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x08)
	.dwattr $C$DW$83, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$83, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$83, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$83, DW_AT_decl_line(0xec)
	.dwattr $C$DW$83, DW_AT_decl_column(0x0d)
$C$DW$84	.dwtag  DW_TAG_member
	.dwattr $C$DW$84, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$84, DW_AT_name("rsvd2")
	.dwattr $C$DW$84, DW_AT_TI_symbol_name("rsvd2")
	.dwattr $C$DW$84, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x18)
	.dwattr $C$DW$84, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$84, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$84, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$84, DW_AT_decl_line(0xed)
	.dwattr $C$DW$84, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$31

	.dwattr $C$DW$T$31, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$31, DW_AT_decl_line(0xeb)
	.dwattr $C$DW$T$31, DW_AT_decl_column(0x13)
$C$DW$T$72	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$72, DW_AT_type(*$C$DW$T$31)

$C$DW$T$35	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$35, DW_AT_byte_size(0x44)
$C$DW$85	.dwtag  DW_TAG_member
	.dwattr $C$DW$85, DW_AT_type(*$C$DW$T$49)
	.dwattr $C$DW$85, DW_AT_name("$P$T0")
	.dwattr $C$DW$85, DW_AT_TI_symbol_name("$P$T0")
	.dwattr $C$DW$85, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$85, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$85, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$85, DW_AT_decl_line(0x29)
	.dwattr $C$DW$85, DW_AT_decl_column(0x02)
$C$DW$86	.dwtag  DW_TAG_member
	.dwattr $C$DW$86, DW_AT_type(*$C$DW$T$51)
	.dwattr $C$DW$86, DW_AT_name("$P$T1")
	.dwattr $C$DW$86, DW_AT_TI_symbol_name("$P$T1")
	.dwattr $C$DW$86, DW_AT_data_member_location[DW_OP_plus_uconst 0x4]
	.dwattr $C$DW$86, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$86, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$86, DW_AT_decl_line(0x33)
	.dwattr $C$DW$86, DW_AT_decl_column(0x02)
$C$DW$87	.dwtag  DW_TAG_member
	.dwattr $C$DW$87, DW_AT_type(*$C$DW$T$53)
	.dwattr $C$DW$87, DW_AT_name("$P$T2")
	.dwattr $C$DW$87, DW_AT_TI_symbol_name("$P$T2")
	.dwattr $C$DW$87, DW_AT_data_member_location[DW_OP_plus_uconst 0x8]
	.dwattr $C$DW$87, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$87, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$87, DW_AT_decl_line(0x41)
	.dwattr $C$DW$87, DW_AT_decl_column(0x02)
$C$DW$88	.dwtag  DW_TAG_member
	.dwattr $C$DW$88, DW_AT_type(*$C$DW$T$55)
	.dwattr $C$DW$88, DW_AT_name("$P$T3")
	.dwattr $C$DW$88, DW_AT_TI_symbol_name("$P$T3")
	.dwattr $C$DW$88, DW_AT_data_member_location[DW_OP_plus_uconst 0xc]
	.dwattr $C$DW$88, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$88, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$88, DW_AT_decl_line(0x54)
	.dwattr $C$DW$88, DW_AT_decl_column(0x02)
$C$DW$89	.dwtag  DW_TAG_member
	.dwattr $C$DW$89, DW_AT_type(*$C$DW$T$57)
	.dwattr $C$DW$89, DW_AT_name("$P$T4")
	.dwattr $C$DW$89, DW_AT_TI_symbol_name("$P$T4")
	.dwattr $C$DW$89, DW_AT_data_member_location[DW_OP_plus_uconst 0x10]
	.dwattr $C$DW$89, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$89, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$89, DW_AT_decl_line(0x67)
	.dwattr $C$DW$89, DW_AT_decl_column(0x02)
$C$DW$90	.dwtag  DW_TAG_member
	.dwattr $C$DW$90, DW_AT_type(*$C$DW$T$59)
	.dwattr $C$DW$90, DW_AT_name("$P$T5")
	.dwattr $C$DW$90, DW_AT_TI_symbol_name("$P$T5")
	.dwattr $C$DW$90, DW_AT_data_member_location[DW_OP_plus_uconst 0x14]
	.dwattr $C$DW$90, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$90, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$90, DW_AT_decl_line(0x83)
	.dwattr $C$DW$90, DW_AT_decl_column(0x02)
$C$DW$91	.dwtag  DW_TAG_member
	.dwattr $C$DW$91, DW_AT_type(*$C$DW$T$61)
	.dwattr $C$DW$91, DW_AT_name("$P$T6")
	.dwattr $C$DW$91, DW_AT_TI_symbol_name("$P$T6")
	.dwattr $C$DW$91, DW_AT_data_member_location[DW_OP_plus_uconst 0x18]
	.dwattr $C$DW$91, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$91, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$91, DW_AT_decl_line(0x92)
	.dwattr $C$DW$91, DW_AT_decl_column(0x02)
$C$DW$92	.dwtag  DW_TAG_member
	.dwattr $C$DW$92, DW_AT_type(*$C$DW$T$63)
	.dwattr $C$DW$92, DW_AT_name("$P$T7")
	.dwattr $C$DW$92, DW_AT_TI_symbol_name("$P$T7")
	.dwattr $C$DW$92, DW_AT_data_member_location[DW_OP_plus_uconst 0x1c]
	.dwattr $C$DW$92, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$92, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$92, DW_AT_decl_line(0xa0)
	.dwattr $C$DW$92, DW_AT_decl_column(0x02)
$C$DW$93	.dwtag  DW_TAG_member
	.dwattr $C$DW$93, DW_AT_type(*$C$DW$T$65)
	.dwattr $C$DW$93, DW_AT_name("$P$T8")
	.dwattr $C$DW$93, DW_AT_TI_symbol_name("$P$T8")
	.dwattr $C$DW$93, DW_AT_data_member_location[DW_OP_plus_uconst 0x20]
	.dwattr $C$DW$93, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$93, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$93, DW_AT_decl_line(0xaf)
	.dwattr $C$DW$93, DW_AT_decl_column(0x02)
$C$DW$94	.dwtag  DW_TAG_member
	.dwattr $C$DW$94, DW_AT_type(*$C$DW$T$32)
	.dwattr $C$DW$94, DW_AT_name("rsvd24")
	.dwattr $C$DW$94, DW_AT_TI_symbol_name("rsvd24")
	.dwattr $C$DW$94, DW_AT_data_member_location[DW_OP_plus_uconst 0x24]
	.dwattr $C$DW$94, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$94, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$94, DW_AT_decl_line(0xbc)
	.dwattr $C$DW$94, DW_AT_decl_column(0x0b)
$C$DW$95	.dwtag  DW_TAG_member
	.dwattr $C$DW$95, DW_AT_type(*$C$DW$T$67)
	.dwattr $C$DW$95, DW_AT_name("$P$T9")
	.dwattr $C$DW$95, DW_AT_TI_symbol_name("$P$T9")
	.dwattr $C$DW$95, DW_AT_data_member_location[DW_OP_plus_uconst 0x28]
	.dwattr $C$DW$95, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$95, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$95, DW_AT_decl_line(0xc0)
	.dwattr $C$DW$95, DW_AT_decl_column(0x02)
$C$DW$96	.dwtag  DW_TAG_member
	.dwattr $C$DW$96, DW_AT_type(*$C$DW$T$33)
	.dwattr $C$DW$96, DW_AT_name("rsvd2c")
	.dwattr $C$DW$96, DW_AT_TI_symbol_name("rsvd2c")
	.dwattr $C$DW$96, DW_AT_data_member_location[DW_OP_plus_uconst 0x2c]
	.dwattr $C$DW$96, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$96, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$96, DW_AT_decl_line(0xcb)
	.dwattr $C$DW$96, DW_AT_decl_column(0x0b)
$C$DW$97	.dwtag  DW_TAG_member
	.dwattr $C$DW$97, DW_AT_type(*$C$DW$T$69)
	.dwattr $C$DW$97, DW_AT_name("$P$T10")
	.dwattr $C$DW$97, DW_AT_TI_symbol_name("$P$T10")
	.dwattr $C$DW$97, DW_AT_data_member_location[DW_OP_plus_uconst 0x30]
	.dwattr $C$DW$97, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$97, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$97, DW_AT_decl_line(0xcf)
	.dwattr $C$DW$97, DW_AT_decl_column(0x02)
$C$DW$98	.dwtag  DW_TAG_member
	.dwattr $C$DW$98, DW_AT_type(*$C$DW$T$71)
	.dwattr $C$DW$98, DW_AT_name("$P$T11")
	.dwattr $C$DW$98, DW_AT_TI_symbol_name("$P$T11")
	.dwattr $C$DW$98, DW_AT_data_member_location[DW_OP_plus_uconst 0x34]
	.dwattr $C$DW$98, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$98, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$98, DW_AT_decl_line(0xda)
	.dwattr $C$DW$98, DW_AT_decl_column(0x02)
$C$DW$99	.dwtag  DW_TAG_member
	.dwattr $C$DW$99, DW_AT_type(*$C$DW$T$34)
	.dwattr $C$DW$99, DW_AT_name("rsvd38")
	.dwattr $C$DW$99, DW_AT_TI_symbol_name("rsvd38")
	.dwattr $C$DW$99, DW_AT_data_member_location[DW_OP_plus_uconst 0x38]
	.dwattr $C$DW$99, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$99, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$99, DW_AT_decl_line(0xe5)
	.dwattr $C$DW$99, DW_AT_decl_column(0x0b)
$C$DW$100	.dwtag  DW_TAG_member
	.dwattr $C$DW$100, DW_AT_type(*$C$DW$T$73)
	.dwattr $C$DW$100, DW_AT_name("$P$T12")
	.dwattr $C$DW$100, DW_AT_TI_symbol_name("$P$T12")
	.dwattr $C$DW$100, DW_AT_data_member_location[DW_OP_plus_uconst 0x40]
	.dwattr $C$DW$100, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$100, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$100, DW_AT_decl_line(0xe8)
	.dwattr $C$DW$100, DW_AT_decl_column(0x02)
	.dwendtag $C$DW$T$35

	.dwattr $C$DW$T$35, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$35, DW_AT_decl_line(0x26)
	.dwattr $C$DW$T$35, DW_AT_decl_column(0x10)
$C$DW$T$97	.dwtag  DW_TAG_typedef, DW_AT_name("pruCfg")
	.dwattr $C$DW$T$97, DW_AT_type(*$C$DW$T$35)
	.dwattr $C$DW$T$97, DW_AT_language(DW_LANG_C)
	.dwattr $C$DW$T$97, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$97, DW_AT_decl_line(0xf0)
	.dwattr $C$DW$T$97, DW_AT_decl_column(0x03)
$C$DW$T$98	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$98, DW_AT_type(*$C$DW$T$97)

$C$DW$T$36	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$36, DW_AT_byte_size(0x04)
$C$DW$101	.dwtag  DW_TAG_member
	.dwattr $C$DW$101, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$101, DW_AT_name("C24_BLK_IDX")
	.dwattr $C$DW$101, DW_AT_TI_symbol_name("C24_BLK_IDX")
	.dwattr $C$DW$101, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x08)
	.dwattr $C$DW$101, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$101, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$101, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$101, DW_AT_decl_line(0x6b)
	.dwattr $C$DW$101, DW_AT_decl_column(0x0d)
$C$DW$102	.dwtag  DW_TAG_member
	.dwattr $C$DW$102, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$102, DW_AT_name("rsvd8")
	.dwattr $C$DW$102, DW_AT_TI_symbol_name("rsvd8")
	.dwattr $C$DW$102, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x08)
	.dwattr $C$DW$102, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$102, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$102, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$102, DW_AT_decl_line(0x6c)
	.dwattr $C$DW$102, DW_AT_decl_column(0x0d)
$C$DW$103	.dwtag  DW_TAG_member
	.dwattr $C$DW$103, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$103, DW_AT_name("C25_BLK_IDX")
	.dwattr $C$DW$103, DW_AT_TI_symbol_name("C25_BLK_IDX")
	.dwattr $C$DW$103, DW_AT_bit_offset(0x08), DW_AT_bit_size(0x08)
	.dwattr $C$DW$103, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$103, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$103, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$103, DW_AT_decl_line(0x6d)
	.dwattr $C$DW$103, DW_AT_decl_column(0x0d)
$C$DW$104	.dwtag  DW_TAG_member
	.dwattr $C$DW$104, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$104, DW_AT_name("rsvd24")
	.dwattr $C$DW$104, DW_AT_TI_symbol_name("rsvd24")
	.dwattr $C$DW$104, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x08)
	.dwattr $C$DW$104, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$104, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$104, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$104, DW_AT_decl_line(0x6e)
	.dwattr $C$DW$104, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$36

	.dwattr $C$DW$T$36, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$36, DW_AT_decl_line(0x6a)
	.dwattr $C$DW$T$36, DW_AT_decl_column(0x13)
$C$DW$T$74	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$74, DW_AT_type(*$C$DW$T$36)

$C$DW$T$37	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$37, DW_AT_byte_size(0x04)
$C$DW$105	.dwtag  DW_TAG_member
	.dwattr $C$DW$105, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$105, DW_AT_name("SOFT_RST_N")
	.dwattr $C$DW$105, DW_AT_TI_symbol_name("SOFT_RST_N")
	.dwattr $C$DW$105, DW_AT_bit_offset(0x1f), DW_AT_bit_size(0x01)
	.dwattr $C$DW$105, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$105, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$105, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$105, DW_AT_decl_line(0x2d)
	.dwattr $C$DW$105, DW_AT_decl_column(0x0d)
$C$DW$106	.dwtag  DW_TAG_member
	.dwattr $C$DW$106, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$106, DW_AT_name("EN")
	.dwattr $C$DW$106, DW_AT_TI_symbol_name("EN")
	.dwattr $C$DW$106, DW_AT_bit_offset(0x1e), DW_AT_bit_size(0x01)
	.dwattr $C$DW$106, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$106, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$106, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$106, DW_AT_decl_line(0x2e)
	.dwattr $C$DW$106, DW_AT_decl_column(0x0d)
$C$DW$107	.dwtag  DW_TAG_member
	.dwattr $C$DW$107, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$107, DW_AT_name("SLEEPING")
	.dwattr $C$DW$107, DW_AT_TI_symbol_name("SLEEPING")
	.dwattr $C$DW$107, DW_AT_bit_offset(0x1d), DW_AT_bit_size(0x01)
	.dwattr $C$DW$107, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$107, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$107, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$107, DW_AT_decl_line(0x2f)
	.dwattr $C$DW$107, DW_AT_decl_column(0x0d)
$C$DW$108	.dwtag  DW_TAG_member
	.dwattr $C$DW$108, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$108, DW_AT_name("CTR_EN")
	.dwattr $C$DW$108, DW_AT_TI_symbol_name("CTR_EN")
	.dwattr $C$DW$108, DW_AT_bit_offset(0x1c), DW_AT_bit_size(0x01)
	.dwattr $C$DW$108, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$108, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$108, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$108, DW_AT_decl_line(0x30)
	.dwattr $C$DW$108, DW_AT_decl_column(0x0d)
$C$DW$109	.dwtag  DW_TAG_member
	.dwattr $C$DW$109, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$109, DW_AT_name("rsvd4")
	.dwattr $C$DW$109, DW_AT_TI_symbol_name("rsvd4")
	.dwattr $C$DW$109, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x04)
	.dwattr $C$DW$109, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$109, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$109, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$109, DW_AT_decl_line(0x31)
	.dwattr $C$DW$109, DW_AT_decl_column(0x0d)
$C$DW$110	.dwtag  DW_TAG_member
	.dwattr $C$DW$110, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$110, DW_AT_name("SINGLE_STEP")
	.dwattr $C$DW$110, DW_AT_TI_symbol_name("SINGLE_STEP")
	.dwattr $C$DW$110, DW_AT_bit_offset(0x17), DW_AT_bit_size(0x01)
	.dwattr $C$DW$110, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$110, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$110, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$110, DW_AT_decl_line(0x32)
	.dwattr $C$DW$110, DW_AT_decl_column(0x0d)
$C$DW$111	.dwtag  DW_TAG_member
	.dwattr $C$DW$111, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$111, DW_AT_name("rsvd9")
	.dwattr $C$DW$111, DW_AT_TI_symbol_name("rsvd9")
	.dwattr $C$DW$111, DW_AT_bit_offset(0x11), DW_AT_bit_size(0x06)
	.dwattr $C$DW$111, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$111, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$111, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$111, DW_AT_decl_line(0x33)
	.dwattr $C$DW$111, DW_AT_decl_column(0x0d)
$C$DW$112	.dwtag  DW_TAG_member
	.dwattr $C$DW$112, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$112, DW_AT_name("RUNSTATE")
	.dwattr $C$DW$112, DW_AT_TI_symbol_name("RUNSTATE")
	.dwattr $C$DW$112, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x01)
	.dwattr $C$DW$112, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$112, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$112, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$112, DW_AT_decl_line(0x34)
	.dwattr $C$DW$112, DW_AT_decl_column(0x0d)
$C$DW$113	.dwtag  DW_TAG_member
	.dwattr $C$DW$113, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$113, DW_AT_name("PCTR_RST_VAL")
	.dwattr $C$DW$113, DW_AT_TI_symbol_name("PCTR_RST_VAL")
	.dwattr $C$DW$113, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x10)
	.dwattr $C$DW$113, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$113, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$113, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$113, DW_AT_decl_line(0x35)
	.dwattr $C$DW$113, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$37

	.dwattr $C$DW$T$37, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$37, DW_AT_decl_line(0x2c)
	.dwattr $C$DW$T$37, DW_AT_decl_column(0x13)
$C$DW$T$76	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$76, DW_AT_type(*$C$DW$T$37)

$C$DW$T$38	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$38, DW_AT_byte_size(0x04)
$C$DW$114	.dwtag  DW_TAG_member
	.dwattr $C$DW$114, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$114, DW_AT_name("PCTR")
	.dwattr $C$DW$114, DW_AT_TI_symbol_name("PCTR")
	.dwattr $C$DW$114, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x10)
	.dwattr $C$DW$114, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$114, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$114, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$114, DW_AT_decl_line(0x3f)
	.dwattr $C$DW$114, DW_AT_decl_column(0x0d)
$C$DW$115	.dwtag  DW_TAG_member
	.dwattr $C$DW$115, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$115, DW_AT_name("rsvd16")
	.dwattr $C$DW$115, DW_AT_TI_symbol_name("rsvd16")
	.dwattr $C$DW$115, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x10)
	.dwattr $C$DW$115, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$115, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$115, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$115, DW_AT_decl_line(0x40)
	.dwattr $C$DW$115, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$38

	.dwattr $C$DW$T$38, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$38, DW_AT_decl_line(0x3e)
	.dwattr $C$DW$T$38, DW_AT_decl_column(0x13)
$C$DW$T$78	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$78, DW_AT_type(*$C$DW$T$38)

$C$DW$T$39	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$39, DW_AT_byte_size(0x04)
$C$DW$116	.dwtag  DW_TAG_member
	.dwattr $C$DW$116, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$116, DW_AT_name("BITWISE_ENS")
	.dwattr $C$DW$116, DW_AT_TI_symbol_name("BITWISE_ENS")
	.dwattr $C$DW$116, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x20)
	.dwattr $C$DW$116, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$116, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$116, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$116, DW_AT_decl_line(0x4a)
	.dwattr $C$DW$116, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$39

	.dwattr $C$DW$T$39, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$39, DW_AT_decl_line(0x49)
	.dwattr $C$DW$T$39, DW_AT_decl_column(0x13)
$C$DW$T$80	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$80, DW_AT_type(*$C$DW$T$39)

$C$DW$T$40	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$40, DW_AT_byte_size(0x04)
$C$DW$117	.dwtag  DW_TAG_member
	.dwattr $C$DW$117, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$117, DW_AT_name("CYCLECOUNT")
	.dwattr $C$DW$117, DW_AT_TI_symbol_name("CYCLECOUNT")
	.dwattr $C$DW$117, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x20)
	.dwattr $C$DW$117, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$117, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$117, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$117, DW_AT_decl_line(0x54)
	.dwattr $C$DW$117, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$40

	.dwattr $C$DW$T$40, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$40, DW_AT_decl_line(0x53)
	.dwattr $C$DW$T$40, DW_AT_decl_column(0x13)
$C$DW$T$82	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$82, DW_AT_type(*$C$DW$T$40)

$C$DW$T$41	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$41, DW_AT_byte_size(0x04)
$C$DW$118	.dwtag  DW_TAG_member
	.dwattr $C$DW$118, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$118, DW_AT_name("STALLCOUNT")
	.dwattr $C$DW$118, DW_AT_TI_symbol_name("STALLCOUNT")
	.dwattr $C$DW$118, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x20)
	.dwattr $C$DW$118, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$118, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$118, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$118, DW_AT_decl_line(0x5e)
	.dwattr $C$DW$118, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$41

	.dwattr $C$DW$T$41, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$41, DW_AT_decl_line(0x5d)
	.dwattr $C$DW$T$41, DW_AT_decl_column(0x14)
$C$DW$T$84	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$84, DW_AT_type(*$C$DW$T$41)

$C$DW$T$42	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$42, DW_AT_byte_size(0x04)
$C$DW$119	.dwtag  DW_TAG_member
	.dwattr $C$DW$119, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$119, DW_AT_name("C26_BLK_IDX")
	.dwattr $C$DW$119, DW_AT_TI_symbol_name("C26_BLK_IDX")
	.dwattr $C$DW$119, DW_AT_bit_offset(0x18), DW_AT_bit_size(0x08)
	.dwattr $C$DW$119, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$119, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$119, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$119, DW_AT_decl_line(0x78)
	.dwattr $C$DW$119, DW_AT_decl_column(0x0d)
$C$DW$120	.dwtag  DW_TAG_member
	.dwattr $C$DW$120, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$120, DW_AT_name("rsvd8")
	.dwattr $C$DW$120, DW_AT_TI_symbol_name("rsvd8")
	.dwattr $C$DW$120, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x08)
	.dwattr $C$DW$120, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$120, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$120, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$120, DW_AT_decl_line(0x79)
	.dwattr $C$DW$120, DW_AT_decl_column(0x0d)
$C$DW$121	.dwtag  DW_TAG_member
	.dwattr $C$DW$121, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$121, DW_AT_name("C27_BLK_IDX")
	.dwattr $C$DW$121, DW_AT_TI_symbol_name("C27_BLK_IDX")
	.dwattr $C$DW$121, DW_AT_bit_offset(0x08), DW_AT_bit_size(0x08)
	.dwattr $C$DW$121, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$121, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$121, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$121, DW_AT_decl_line(0x7a)
	.dwattr $C$DW$121, DW_AT_decl_column(0x0d)
$C$DW$122	.dwtag  DW_TAG_member
	.dwattr $C$DW$122, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$122, DW_AT_name("rsvd24")
	.dwattr $C$DW$122, DW_AT_TI_symbol_name("rsvd24")
	.dwattr $C$DW$122, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x08)
	.dwattr $C$DW$122, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$122, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$122, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$122, DW_AT_decl_line(0x7b)
	.dwattr $C$DW$122, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$42

	.dwattr $C$DW$T$42, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$42, DW_AT_decl_line(0x77)
	.dwattr $C$DW$T$42, DW_AT_decl_column(0x13)
$C$DW$T$86	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$86, DW_AT_type(*$C$DW$T$42)

$C$DW$T$43	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$43, DW_AT_byte_size(0x04)
$C$DW$123	.dwtag  DW_TAG_member
	.dwattr $C$DW$123, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$123, DW_AT_name("C28_BLK_POINTER")
	.dwattr $C$DW$123, DW_AT_TI_symbol_name("C28_BLK_POINTER")
	.dwattr $C$DW$123, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x10)
	.dwattr $C$DW$123, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$123, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$123, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$123, DW_AT_decl_line(0x85)
	.dwattr $C$DW$123, DW_AT_decl_column(0x0d)
$C$DW$124	.dwtag  DW_TAG_member
	.dwattr $C$DW$124, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$124, DW_AT_name("C29_BLK_POINTER")
	.dwattr $C$DW$124, DW_AT_TI_symbol_name("C29_BLK_POINTER")
	.dwattr $C$DW$124, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x10)
	.dwattr $C$DW$124, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$124, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$124, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$124, DW_AT_decl_line(0x86)
	.dwattr $C$DW$124, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$43

	.dwattr $C$DW$T$43, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$43, DW_AT_decl_line(0x84)
	.dwattr $C$DW$T$43, DW_AT_decl_column(0x13)
$C$DW$T$88	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$88, DW_AT_type(*$C$DW$T$43)

$C$DW$T$44	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$44, DW_AT_byte_size(0x04)
$C$DW$125	.dwtag  DW_TAG_member
	.dwattr $C$DW$125, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$125, DW_AT_name("C30_BLK_POINTER")
	.dwattr $C$DW$125, DW_AT_TI_symbol_name("C30_BLK_POINTER")
	.dwattr $C$DW$125, DW_AT_bit_offset(0x10), DW_AT_bit_size(0x10)
	.dwattr $C$DW$125, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$125, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$125, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$125, DW_AT_decl_line(0x90)
	.dwattr $C$DW$125, DW_AT_decl_column(0x0d)
$C$DW$126	.dwtag  DW_TAG_member
	.dwattr $C$DW$126, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$126, DW_AT_name("C31_BLK_POINTER")
	.dwattr $C$DW$126, DW_AT_TI_symbol_name("C31_BLK_POINTER")
	.dwattr $C$DW$126, DW_AT_bit_offset(0x00), DW_AT_bit_size(0x10)
	.dwattr $C$DW$126, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$126, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$126, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$126, DW_AT_decl_line(0x91)
	.dwattr $C$DW$126, DW_AT_decl_column(0x0d)
	.dwendtag $C$DW$T$44

	.dwattr $C$DW$T$44, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$44, DW_AT_decl_line(0x8f)
	.dwattr $C$DW$T$44, DW_AT_decl_column(0x13)
$C$DW$T$90	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$90, DW_AT_type(*$C$DW$T$44)

$C$DW$T$46	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$46, DW_AT_byte_size(0x30)
$C$DW$127	.dwtag  DW_TAG_member
	.dwattr $C$DW$127, DW_AT_type(*$C$DW$T$77)
	.dwattr $C$DW$127, DW_AT_name("$P$T13")
	.dwattr $C$DW$127, DW_AT_TI_symbol_name("$P$T13")
	.dwattr $C$DW$127, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$127, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$127, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$127, DW_AT_decl_line(0x29)
	.dwattr $C$DW$127, DW_AT_decl_column(0x02)
$C$DW$128	.dwtag  DW_TAG_member
	.dwattr $C$DW$128, DW_AT_type(*$C$DW$T$79)
	.dwattr $C$DW$128, DW_AT_name("$P$T14")
	.dwattr $C$DW$128, DW_AT_TI_symbol_name("$P$T14")
	.dwattr $C$DW$128, DW_AT_data_member_location[DW_OP_plus_uconst 0x4]
	.dwattr $C$DW$128, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$128, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$128, DW_AT_decl_line(0x3b)
	.dwattr $C$DW$128, DW_AT_decl_column(0x02)
$C$DW$129	.dwtag  DW_TAG_member
	.dwattr $C$DW$129, DW_AT_type(*$C$DW$T$81)
	.dwattr $C$DW$129, DW_AT_name("$P$T15")
	.dwattr $C$DW$129, DW_AT_TI_symbol_name("$P$T15")
	.dwattr $C$DW$129, DW_AT_data_member_location[DW_OP_plus_uconst 0x8]
	.dwattr $C$DW$129, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$129, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$129, DW_AT_decl_line(0x46)
	.dwattr $C$DW$129, DW_AT_decl_column(0x02)
$C$DW$130	.dwtag  DW_TAG_member
	.dwattr $C$DW$130, DW_AT_type(*$C$DW$T$83)
	.dwattr $C$DW$130, DW_AT_name("$P$T16")
	.dwattr $C$DW$130, DW_AT_TI_symbol_name("$P$T16")
	.dwattr $C$DW$130, DW_AT_data_member_location[DW_OP_plus_uconst 0xc]
	.dwattr $C$DW$130, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$130, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$130, DW_AT_decl_line(0x50)
	.dwattr $C$DW$130, DW_AT_decl_column(0x02)
$C$DW$131	.dwtag  DW_TAG_member
	.dwattr $C$DW$131, DW_AT_type(*$C$DW$T$85)
	.dwattr $C$DW$131, DW_AT_name("$P$T17")
	.dwattr $C$DW$131, DW_AT_TI_symbol_name("$P$T17")
	.dwattr $C$DW$131, DW_AT_data_member_location[DW_OP_plus_uconst 0x10]
	.dwattr $C$DW$131, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$131, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$131, DW_AT_decl_line(0x5a)
	.dwattr $C$DW$131, DW_AT_decl_column(0x02)
$C$DW$132	.dwtag  DW_TAG_member
	.dwattr $C$DW$132, DW_AT_type(*$C$DW$T$45)
	.dwattr $C$DW$132, DW_AT_name("rsvd14")
	.dwattr $C$DW$132, DW_AT_TI_symbol_name("rsvd14")
	.dwattr $C$DW$132, DW_AT_data_member_location[DW_OP_plus_uconst 0x14]
	.dwattr $C$DW$132, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$132, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$132, DW_AT_decl_line(0x63)
	.dwattr $C$DW$132, DW_AT_decl_column(0x0b)
$C$DW$133	.dwtag  DW_TAG_member
	.dwattr $C$DW$133, DW_AT_type(*$C$DW$T$75)
	.dwattr $C$DW$133, DW_AT_name("$P$T18")
	.dwattr $C$DW$133, DW_AT_TI_symbol_name("$P$T18")
	.dwattr $C$DW$133, DW_AT_data_member_location[DW_OP_plus_uconst 0x20]
	.dwattr $C$DW$133, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$133, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$133, DW_AT_decl_line(0x67)
	.dwattr $C$DW$133, DW_AT_decl_column(0x02)
$C$DW$134	.dwtag  DW_TAG_member
	.dwattr $C$DW$134, DW_AT_type(*$C$DW$T$87)
	.dwattr $C$DW$134, DW_AT_name("$P$T19")
	.dwattr $C$DW$134, DW_AT_TI_symbol_name("$P$T19")
	.dwattr $C$DW$134, DW_AT_data_member_location[DW_OP_plus_uconst 0x24]
	.dwattr $C$DW$134, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$134, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$134, DW_AT_decl_line(0x74)
	.dwattr $C$DW$134, DW_AT_decl_column(0x02)
$C$DW$135	.dwtag  DW_TAG_member
	.dwattr $C$DW$135, DW_AT_type(*$C$DW$T$89)
	.dwattr $C$DW$135, DW_AT_name("$P$T20")
	.dwattr $C$DW$135, DW_AT_TI_symbol_name("$P$T20")
	.dwattr $C$DW$135, DW_AT_data_member_location[DW_OP_plus_uconst 0x28]
	.dwattr $C$DW$135, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$135, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$135, DW_AT_decl_line(0x81)
	.dwattr $C$DW$135, DW_AT_decl_column(0x02)
$C$DW$136	.dwtag  DW_TAG_member
	.dwattr $C$DW$136, DW_AT_type(*$C$DW$T$91)
	.dwattr $C$DW$136, DW_AT_name("$P$T21")
	.dwattr $C$DW$136, DW_AT_TI_symbol_name("$P$T21")
	.dwattr $C$DW$136, DW_AT_data_member_location[DW_OP_plus_uconst 0x2c]
	.dwattr $C$DW$136, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$136, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$136, DW_AT_decl_line(0x8c)
	.dwattr $C$DW$136, DW_AT_decl_column(0x02)
	.dwendtag $C$DW$T$46

	.dwattr $C$DW$T$46, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$46, DW_AT_decl_line(0x26)
	.dwattr $C$DW$T$46, DW_AT_decl_column(0x10)
$C$DW$T$101	.dwtag  DW_TAG_typedef, DW_AT_name("pruCtrl")
	.dwattr $C$DW$T$101, DW_AT_type(*$C$DW$T$46)
	.dwattr $C$DW$T$101, DW_AT_language(DW_LANG_C)
	.dwattr $C$DW$T$101, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$101, DW_AT_decl_line(0x95)
	.dwattr $C$DW$T$101, DW_AT_decl_column(0x03)

$C$DW$T$49	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$49, DW_AT_byte_size(0x04)
$C$DW$137	.dwtag  DW_TAG_member
	.dwattr $C$DW$137, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$137, DW_AT_name("REVID")
	.dwattr $C$DW$137, DW_AT_TI_symbol_name("REVID")
	.dwattr $C$DW$137, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$137, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$137, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$137, DW_AT_decl_line(0x2a)
	.dwattr $C$DW$137, DW_AT_decl_column(0x15)
$C$DW$138	.dwtag  DW_TAG_member
	.dwattr $C$DW$138, DW_AT_type(*$C$DW$T$48)
	.dwattr $C$DW$138, DW_AT_name("REVID_bit")
	.dwattr $C$DW$138, DW_AT_TI_symbol_name("REVID_bit")
	.dwattr $C$DW$138, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$138, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$138, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$138, DW_AT_decl_line(0x2e)
	.dwattr $C$DW$138, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$49

	.dwattr $C$DW$T$49, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$49, DW_AT_decl_line(0x29)
	.dwattr $C$DW$T$49, DW_AT_decl_column(0x08)

$C$DW$T$51	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$51, DW_AT_byte_size(0x04)
$C$DW$139	.dwtag  DW_TAG_member
	.dwattr $C$DW$139, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$139, DW_AT_name("SYSCFG")
	.dwattr $C$DW$139, DW_AT_TI_symbol_name("SYSCFG")
	.dwattr $C$DW$139, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$139, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$139, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$139, DW_AT_decl_line(0x34)
	.dwattr $C$DW$139, DW_AT_decl_column(0x15)
$C$DW$140	.dwtag  DW_TAG_member
	.dwattr $C$DW$140, DW_AT_type(*$C$DW$T$50)
	.dwattr $C$DW$140, DW_AT_name("SYSCFG_bit")
	.dwattr $C$DW$140, DW_AT_TI_symbol_name("SYSCFG_bit")
	.dwattr $C$DW$140, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$140, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$140, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$140, DW_AT_decl_line(0x3c)
	.dwattr $C$DW$140, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$51

	.dwattr $C$DW$T$51, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$51, DW_AT_decl_line(0x33)
	.dwattr $C$DW$T$51, DW_AT_decl_column(0x08)

$C$DW$T$53	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$53, DW_AT_byte_size(0x04)
$C$DW$141	.dwtag  DW_TAG_member
	.dwattr $C$DW$141, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$141, DW_AT_name("GPCFG0")
	.dwattr $C$DW$141, DW_AT_TI_symbol_name("GPCFG0")
	.dwattr $C$DW$141, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$141, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$141, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$141, DW_AT_decl_line(0x42)
	.dwattr $C$DW$141, DW_AT_decl_column(0x15)
$C$DW$142	.dwtag  DW_TAG_member
	.dwattr $C$DW$142, DW_AT_type(*$C$DW$T$52)
	.dwattr $C$DW$142, DW_AT_name("GPCFG0_bit")
	.dwattr $C$DW$142, DW_AT_TI_symbol_name("GPCFG0_bit")
	.dwattr $C$DW$142, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$142, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$142, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$142, DW_AT_decl_line(0x4f)
	.dwattr $C$DW$142, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$53

	.dwattr $C$DW$T$53, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$53, DW_AT_decl_line(0x41)
	.dwattr $C$DW$T$53, DW_AT_decl_column(0x08)

$C$DW$T$55	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$55, DW_AT_byte_size(0x04)
$C$DW$143	.dwtag  DW_TAG_member
	.dwattr $C$DW$143, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$143, DW_AT_name("GPCFG1")
	.dwattr $C$DW$143, DW_AT_TI_symbol_name("GPCFG1")
	.dwattr $C$DW$143, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$143, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$143, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$143, DW_AT_decl_line(0x55)
	.dwattr $C$DW$143, DW_AT_decl_column(0x15)
$C$DW$144	.dwtag  DW_TAG_member
	.dwattr $C$DW$144, DW_AT_type(*$C$DW$T$54)
	.dwattr $C$DW$144, DW_AT_name("GPCFG1_bit")
	.dwattr $C$DW$144, DW_AT_TI_symbol_name("GPCFG1_bit")
	.dwattr $C$DW$144, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$144, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$144, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$144, DW_AT_decl_line(0x62)
	.dwattr $C$DW$144, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$55

	.dwattr $C$DW$T$55, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$55, DW_AT_decl_line(0x54)
	.dwattr $C$DW$T$55, DW_AT_decl_column(0x08)

$C$DW$T$57	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$57, DW_AT_byte_size(0x04)
$C$DW$145	.dwtag  DW_TAG_member
	.dwattr $C$DW$145, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$145, DW_AT_name("CGR")
	.dwattr $C$DW$145, DW_AT_TI_symbol_name("CGR")
	.dwattr $C$DW$145, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$145, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$145, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$145, DW_AT_decl_line(0x68)
	.dwattr $C$DW$145, DW_AT_decl_column(0x15)
$C$DW$146	.dwtag  DW_TAG_member
	.dwattr $C$DW$146, DW_AT_type(*$C$DW$T$56)
	.dwattr $C$DW$146, DW_AT_name("CGR_bit")
	.dwattr $C$DW$146, DW_AT_TI_symbol_name("CGR_bit")
	.dwattr $C$DW$146, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$146, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$146, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$146, DW_AT_decl_line(0x7e)
	.dwattr $C$DW$146, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$57

	.dwattr $C$DW$T$57, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$57, DW_AT_decl_line(0x67)
	.dwattr $C$DW$T$57, DW_AT_decl_column(0x08)

$C$DW$T$59	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$59, DW_AT_byte_size(0x04)
$C$DW$147	.dwtag  DW_TAG_member
	.dwattr $C$DW$147, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$147, DW_AT_name("ISRP")
	.dwattr $C$DW$147, DW_AT_TI_symbol_name("ISRP")
	.dwattr $C$DW$147, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$147, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$147, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$147, DW_AT_decl_line(0x84)
	.dwattr $C$DW$147, DW_AT_decl_column(0x15)
$C$DW$148	.dwtag  DW_TAG_member
	.dwattr $C$DW$148, DW_AT_type(*$C$DW$T$58)
	.dwattr $C$DW$148, DW_AT_name("ISRP_bit")
	.dwattr $C$DW$148, DW_AT_TI_symbol_name("ISRP_bit")
	.dwattr $C$DW$148, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$148, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$148, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$148, DW_AT_decl_line(0x8d)
	.dwattr $C$DW$148, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$59

	.dwattr $C$DW$T$59, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$59, DW_AT_decl_line(0x83)
	.dwattr $C$DW$T$59, DW_AT_decl_column(0x08)

$C$DW$T$61	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$61, DW_AT_byte_size(0x04)
$C$DW$149	.dwtag  DW_TAG_member
	.dwattr $C$DW$149, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$149, DW_AT_name("ISP")
	.dwattr $C$DW$149, DW_AT_TI_symbol_name("ISP")
	.dwattr $C$DW$149, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$149, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$149, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$149, DW_AT_decl_line(0x93)
	.dwattr $C$DW$149, DW_AT_decl_column(0x15)
$C$DW$150	.dwtag  DW_TAG_member
	.dwattr $C$DW$150, DW_AT_type(*$C$DW$T$60)
	.dwattr $C$DW$150, DW_AT_name("ISP_bit")
	.dwattr $C$DW$150, DW_AT_TI_symbol_name("ISP_bit")
	.dwattr $C$DW$150, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$150, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$150, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$150, DW_AT_decl_line(0x9c)
	.dwattr $C$DW$150, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$61

	.dwattr $C$DW$T$61, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$61, DW_AT_decl_line(0x92)
	.dwattr $C$DW$T$61, DW_AT_decl_column(0x08)

$C$DW$T$63	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$63, DW_AT_byte_size(0x04)
$C$DW$151	.dwtag  DW_TAG_member
	.dwattr $C$DW$151, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$151, DW_AT_name("IESP")
	.dwattr $C$DW$151, DW_AT_TI_symbol_name("IESP")
	.dwattr $C$DW$151, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$151, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$151, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$151, DW_AT_decl_line(0xa1)
	.dwattr $C$DW$151, DW_AT_decl_column(0x15)
$C$DW$152	.dwtag  DW_TAG_member
	.dwattr $C$DW$152, DW_AT_type(*$C$DW$T$62)
	.dwattr $C$DW$152, DW_AT_name("IESP_bit")
	.dwattr $C$DW$152, DW_AT_TI_symbol_name("IESP_bit")
	.dwattr $C$DW$152, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$152, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$152, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$152, DW_AT_decl_line(0xaa)
	.dwattr $C$DW$152, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$63

	.dwattr $C$DW$T$63, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$63, DW_AT_decl_line(0xa0)
	.dwattr $C$DW$T$63, DW_AT_decl_column(0x08)

$C$DW$T$65	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$65, DW_AT_byte_size(0x04)
$C$DW$153	.dwtag  DW_TAG_member
	.dwattr $C$DW$153, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$153, DW_AT_name("IECP")
	.dwattr $C$DW$153, DW_AT_TI_symbol_name("IECP")
	.dwattr $C$DW$153, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$153, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$153, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$153, DW_AT_decl_line(0xb0)
	.dwattr $C$DW$153, DW_AT_decl_column(0x15)
$C$DW$154	.dwtag  DW_TAG_member
	.dwattr $C$DW$154, DW_AT_type(*$C$DW$T$64)
	.dwattr $C$DW$154, DW_AT_name("IECP_bit")
	.dwattr $C$DW$154, DW_AT_TI_symbol_name("IECP_bit")
	.dwattr $C$DW$154, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$154, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$154, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$154, DW_AT_decl_line(0xb8)
	.dwattr $C$DW$154, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$65

	.dwattr $C$DW$T$65, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$65, DW_AT_decl_line(0xaf)
	.dwattr $C$DW$T$65, DW_AT_decl_column(0x08)

$C$DW$T$67	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$67, DW_AT_byte_size(0x04)
$C$DW$155	.dwtag  DW_TAG_member
	.dwattr $C$DW$155, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$155, DW_AT_name("PMAO")
	.dwattr $C$DW$155, DW_AT_TI_symbol_name("PMAO")
	.dwattr $C$DW$155, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$155, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$155, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$155, DW_AT_decl_line(0xc1)
	.dwattr $C$DW$155, DW_AT_decl_column(0x15)
$C$DW$156	.dwtag  DW_TAG_member
	.dwattr $C$DW$156, DW_AT_type(*$C$DW$T$66)
	.dwattr $C$DW$156, DW_AT_name("PMAO_bit")
	.dwattr $C$DW$156, DW_AT_TI_symbol_name("PMAO_bit")
	.dwattr $C$DW$156, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$156, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$156, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$156, DW_AT_decl_line(0xc7)
	.dwattr $C$DW$156, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$67

	.dwattr $C$DW$T$67, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$67, DW_AT_decl_line(0xc0)
	.dwattr $C$DW$T$67, DW_AT_decl_column(0x08)

$C$DW$T$69	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$69, DW_AT_byte_size(0x04)
$C$DW$157	.dwtag  DW_TAG_member
	.dwattr $C$DW$157, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$157, DW_AT_name("IEPCLK")
	.dwattr $C$DW$157, DW_AT_TI_symbol_name("IEPCLK")
	.dwattr $C$DW$157, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$157, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$157, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$157, DW_AT_decl_line(0xd0)
	.dwattr $C$DW$157, DW_AT_decl_column(0x15)
$C$DW$158	.dwtag  DW_TAG_member
	.dwattr $C$DW$158, DW_AT_type(*$C$DW$T$68)
	.dwattr $C$DW$158, DW_AT_name("IEPCLK_bit")
	.dwattr $C$DW$158, DW_AT_TI_symbol_name("IEPCLK_bit")
	.dwattr $C$DW$158, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$158, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$158, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$158, DW_AT_decl_line(0xd5)
	.dwattr $C$DW$158, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$69

	.dwattr $C$DW$T$69, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$69, DW_AT_decl_line(0xcf)
	.dwattr $C$DW$T$69, DW_AT_decl_column(0x08)

$C$DW$T$71	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$71, DW_AT_byte_size(0x04)
$C$DW$159	.dwtag  DW_TAG_member
	.dwattr $C$DW$159, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$159, DW_AT_name("SPP")
	.dwattr $C$DW$159, DW_AT_TI_symbol_name("SPP")
	.dwattr $C$DW$159, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$159, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$159, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$159, DW_AT_decl_line(0xdb)
	.dwattr $C$DW$159, DW_AT_decl_column(0x15)
$C$DW$160	.dwtag  DW_TAG_member
	.dwattr $C$DW$160, DW_AT_type(*$C$DW$T$70)
	.dwattr $C$DW$160, DW_AT_name("SPP_bit")
	.dwattr $C$DW$160, DW_AT_TI_symbol_name("SPP_bit")
	.dwattr $C$DW$160, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$160, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$160, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$160, DW_AT_decl_line(0xe1)
	.dwattr $C$DW$160, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$71

	.dwattr $C$DW$T$71, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$71, DW_AT_decl_line(0xda)
	.dwattr $C$DW$T$71, DW_AT_decl_column(0x08)

$C$DW$T$73	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$73, DW_AT_byte_size(0x04)
$C$DW$161	.dwtag  DW_TAG_member
	.dwattr $C$DW$161, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$161, DW_AT_name("PIN_MX")
	.dwattr $C$DW$161, DW_AT_TI_symbol_name("PIN_MX")
	.dwattr $C$DW$161, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$161, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$161, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$161, DW_AT_decl_line(0xe9)
	.dwattr $C$DW$161, DW_AT_decl_column(0x15)
$C$DW$162	.dwtag  DW_TAG_member
	.dwattr $C$DW$162, DW_AT_type(*$C$DW$T$72)
	.dwattr $C$DW$162, DW_AT_name("PIN_MX_bit")
	.dwattr $C$DW$162, DW_AT_TI_symbol_name("PIN_MX_bit")
	.dwattr $C$DW$162, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$162, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$162, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$162, DW_AT_decl_line(0xee)
	.dwattr $C$DW$162, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$73

	.dwattr $C$DW$T$73, DW_AT_decl_file("../../include/am335x/pru_cfg.h")
	.dwattr $C$DW$T$73, DW_AT_decl_line(0xe8)
	.dwattr $C$DW$T$73, DW_AT_decl_column(0x08)

$C$DW$T$75	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$75, DW_AT_byte_size(0x04)
$C$DW$163	.dwtag  DW_TAG_member
	.dwattr $C$DW$163, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$163, DW_AT_name("CTBIR0")
	.dwattr $C$DW$163, DW_AT_TI_symbol_name("CTBIR0")
	.dwattr $C$DW$163, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$163, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$163, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$163, DW_AT_decl_line(0x68)
	.dwattr $C$DW$163, DW_AT_decl_column(0x15)
$C$DW$164	.dwtag  DW_TAG_member
	.dwattr $C$DW$164, DW_AT_type(*$C$DW$T$74)
	.dwattr $C$DW$164, DW_AT_name("CTBIR0_bit")
	.dwattr $C$DW$164, DW_AT_TI_symbol_name("CTBIR0_bit")
	.dwattr $C$DW$164, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$164, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$164, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$164, DW_AT_decl_line(0x6f)
	.dwattr $C$DW$164, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$75

	.dwattr $C$DW$T$75, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$75, DW_AT_decl_line(0x67)
	.dwattr $C$DW$T$75, DW_AT_decl_column(0x08)

$C$DW$T$77	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$77, DW_AT_byte_size(0x04)
$C$DW$165	.dwtag  DW_TAG_member
	.dwattr $C$DW$165, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$165, DW_AT_name("CTRL")
	.dwattr $C$DW$165, DW_AT_TI_symbol_name("CTRL")
	.dwattr $C$DW$165, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$165, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$165, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$165, DW_AT_decl_line(0x2a)
	.dwattr $C$DW$165, DW_AT_decl_column(0x15)
$C$DW$166	.dwtag  DW_TAG_member
	.dwattr $C$DW$166, DW_AT_type(*$C$DW$T$76)
	.dwattr $C$DW$166, DW_AT_name("CTRL_bit")
	.dwattr $C$DW$166, DW_AT_TI_symbol_name("CTRL_bit")
	.dwattr $C$DW$166, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$166, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$166, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$166, DW_AT_decl_line(0x36)
	.dwattr $C$DW$166, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$77

	.dwattr $C$DW$T$77, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$77, DW_AT_decl_line(0x29)
	.dwattr $C$DW$T$77, DW_AT_decl_column(0x08)

$C$DW$T$79	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$79, DW_AT_byte_size(0x04)
$C$DW$167	.dwtag  DW_TAG_member
	.dwattr $C$DW$167, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$167, DW_AT_name("STS")
	.dwattr $C$DW$167, DW_AT_TI_symbol_name("STS")
	.dwattr $C$DW$167, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$167, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$167, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$167, DW_AT_decl_line(0x3c)
	.dwattr $C$DW$167, DW_AT_decl_column(0x15)
$C$DW$168	.dwtag  DW_TAG_member
	.dwattr $C$DW$168, DW_AT_type(*$C$DW$T$78)
	.dwattr $C$DW$168, DW_AT_name("STS_bit")
	.dwattr $C$DW$168, DW_AT_TI_symbol_name("STS_bit")
	.dwattr $C$DW$168, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$168, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$168, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$168, DW_AT_decl_line(0x41)
	.dwattr $C$DW$168, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$79

	.dwattr $C$DW$T$79, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$79, DW_AT_decl_line(0x3b)
	.dwattr $C$DW$T$79, DW_AT_decl_column(0x08)

$C$DW$T$81	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$81, DW_AT_byte_size(0x04)
$C$DW$169	.dwtag  DW_TAG_member
	.dwattr $C$DW$169, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$169, DW_AT_name("WAKEUP_EN")
	.dwattr $C$DW$169, DW_AT_TI_symbol_name("WAKEUP_EN")
	.dwattr $C$DW$169, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$169, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$169, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$169, DW_AT_decl_line(0x47)
	.dwattr $C$DW$169, DW_AT_decl_column(0x15)
$C$DW$170	.dwtag  DW_TAG_member
	.dwattr $C$DW$170, DW_AT_type(*$C$DW$T$80)
	.dwattr $C$DW$170, DW_AT_name("WAKEUP_EN_bit")
	.dwattr $C$DW$170, DW_AT_TI_symbol_name("WAKEUP_EN_bit")
	.dwattr $C$DW$170, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$170, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$170, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$170, DW_AT_decl_line(0x4b)
	.dwattr $C$DW$170, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$81

	.dwattr $C$DW$T$81, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$81, DW_AT_decl_line(0x46)
	.dwattr $C$DW$T$81, DW_AT_decl_column(0x08)

$C$DW$T$83	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$83, DW_AT_byte_size(0x04)
$C$DW$171	.dwtag  DW_TAG_member
	.dwattr $C$DW$171, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$171, DW_AT_name("CYCLE")
	.dwattr $C$DW$171, DW_AT_TI_symbol_name("CYCLE")
	.dwattr $C$DW$171, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$171, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$171, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$171, DW_AT_decl_line(0x51)
	.dwattr $C$DW$171, DW_AT_decl_column(0x15)
$C$DW$172	.dwtag  DW_TAG_member
	.dwattr $C$DW$172, DW_AT_type(*$C$DW$T$82)
	.dwattr $C$DW$172, DW_AT_name("CYCLE_bit")
	.dwattr $C$DW$172, DW_AT_TI_symbol_name("CYCLE_bit")
	.dwattr $C$DW$172, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$172, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$172, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$172, DW_AT_decl_line(0x55)
	.dwattr $C$DW$172, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$83

	.dwattr $C$DW$T$83, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$83, DW_AT_decl_line(0x50)
	.dwattr $C$DW$T$83, DW_AT_decl_column(0x08)

$C$DW$T$85	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$85, DW_AT_byte_size(0x04)
$C$DW$173	.dwtag  DW_TAG_member
	.dwattr $C$DW$173, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$173, DW_AT_name("STALL")
	.dwattr $C$DW$173, DW_AT_TI_symbol_name("STALL")
	.dwattr $C$DW$173, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$173, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$173, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$173, DW_AT_decl_line(0x5b)
	.dwattr $C$DW$173, DW_AT_decl_column(0x15)
$C$DW$174	.dwtag  DW_TAG_member
	.dwattr $C$DW$174, DW_AT_type(*$C$DW$T$84)
	.dwattr $C$DW$174, DW_AT_name("STALL_bit")
	.dwattr $C$DW$174, DW_AT_TI_symbol_name("STALL_bit")
	.dwattr $C$DW$174, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$174, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$174, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$174, DW_AT_decl_line(0x5f)
	.dwattr $C$DW$174, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$85

	.dwattr $C$DW$T$85, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$85, DW_AT_decl_line(0x5a)
	.dwattr $C$DW$T$85, DW_AT_decl_column(0x08)

$C$DW$T$87	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$87, DW_AT_byte_size(0x04)
$C$DW$175	.dwtag  DW_TAG_member
	.dwattr $C$DW$175, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$175, DW_AT_name("CTBIR1")
	.dwattr $C$DW$175, DW_AT_TI_symbol_name("CTBIR1")
	.dwattr $C$DW$175, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$175, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$175, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$175, DW_AT_decl_line(0x75)
	.dwattr $C$DW$175, DW_AT_decl_column(0x15)
$C$DW$176	.dwtag  DW_TAG_member
	.dwattr $C$DW$176, DW_AT_type(*$C$DW$T$86)
	.dwattr $C$DW$176, DW_AT_name("CTBIR1_bit")
	.dwattr $C$DW$176, DW_AT_TI_symbol_name("CTBIR1_bit")
	.dwattr $C$DW$176, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$176, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$176, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$176, DW_AT_decl_line(0x7c)
	.dwattr $C$DW$176, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$87

	.dwattr $C$DW$T$87, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$87, DW_AT_decl_line(0x74)
	.dwattr $C$DW$T$87, DW_AT_decl_column(0x08)

$C$DW$T$89	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$89, DW_AT_byte_size(0x04)
$C$DW$177	.dwtag  DW_TAG_member
	.dwattr $C$DW$177, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$177, DW_AT_name("CTPPR0")
	.dwattr $C$DW$177, DW_AT_TI_symbol_name("CTPPR0")
	.dwattr $C$DW$177, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$177, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$177, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$177, DW_AT_decl_line(0x82)
	.dwattr $C$DW$177, DW_AT_decl_column(0x15)
$C$DW$178	.dwtag  DW_TAG_member
	.dwattr $C$DW$178, DW_AT_type(*$C$DW$T$88)
	.dwattr $C$DW$178, DW_AT_name("CTPPR0_bit")
	.dwattr $C$DW$178, DW_AT_TI_symbol_name("CTPPR0_bit")
	.dwattr $C$DW$178, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$178, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$178, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$178, DW_AT_decl_line(0x87)
	.dwattr $C$DW$178, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$89

	.dwattr $C$DW$T$89, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$89, DW_AT_decl_line(0x81)
	.dwattr $C$DW$T$89, DW_AT_decl_column(0x08)

$C$DW$T$91	.dwtag  DW_TAG_union_type
	.dwattr $C$DW$T$91, DW_AT_byte_size(0x04)
$C$DW$179	.dwtag  DW_TAG_member
	.dwattr $C$DW$179, DW_AT_type(*$C$DW$T$47)
	.dwattr $C$DW$179, DW_AT_name("CTPPR1")
	.dwattr $C$DW$179, DW_AT_TI_symbol_name("CTPPR1")
	.dwattr $C$DW$179, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$179, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$179, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$179, DW_AT_decl_line(0x8d)
	.dwattr $C$DW$179, DW_AT_decl_column(0x15)
$C$DW$180	.dwtag  DW_TAG_member
	.dwattr $C$DW$180, DW_AT_type(*$C$DW$T$90)
	.dwattr $C$DW$180, DW_AT_name("CTPPR1_bit")
	.dwattr $C$DW$180, DW_AT_TI_symbol_name("CTPPR1_bit")
	.dwattr $C$DW$180, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$180, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$180, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$180, DW_AT_decl_line(0x92)
	.dwattr $C$DW$180, DW_AT_decl_column(0x05)
	.dwendtag $C$DW$T$91

	.dwattr $C$DW$T$91, DW_AT_decl_file("../../include/am335x/pru_ctrl.h")
	.dwattr $C$DW$T$91, DW_AT_decl_line(0x8c)
	.dwattr $C$DW$T$91, DW_AT_decl_column(0x08)
$C$DW$T$2	.dwtag  DW_TAG_unspecified_type
	.dwattr $C$DW$T$2, DW_AT_name("void")
$C$DW$T$4	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$4, DW_AT_encoding(DW_ATE_boolean)
	.dwattr $C$DW$T$4, DW_AT_name("bool")
	.dwattr $C$DW$T$4, DW_AT_byte_size(0x01)
$C$DW$T$5	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$5, DW_AT_encoding(DW_ATE_signed_char)
	.dwattr $C$DW$T$5, DW_AT_name("signed char")
	.dwattr $C$DW$T$5, DW_AT_byte_size(0x01)
$C$DW$T$6	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$6, DW_AT_encoding(DW_ATE_unsigned_char)
	.dwattr $C$DW$T$6, DW_AT_name("unsigned char")
	.dwattr $C$DW$T$6, DW_AT_byte_size(0x01)
$C$DW$T$7	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$7, DW_AT_encoding(DW_ATE_signed_char)
	.dwattr $C$DW$T$7, DW_AT_name("wchar_t")
	.dwattr $C$DW$T$7, DW_AT_byte_size(0x04)
$C$DW$T$8	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$8, DW_AT_encoding(DW_ATE_signed)
	.dwattr $C$DW$T$8, DW_AT_name("short")
	.dwattr $C$DW$T$8, DW_AT_byte_size(0x02)
$C$DW$T$9	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$9, DW_AT_encoding(DW_ATE_unsigned)
	.dwattr $C$DW$T$9, DW_AT_name("unsigned short")
	.dwattr $C$DW$T$9, DW_AT_byte_size(0x02)
$C$DW$T$10	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$10, DW_AT_encoding(DW_ATE_signed)
	.dwattr $C$DW$T$10, DW_AT_name("int")
	.dwattr $C$DW$T$10, DW_AT_byte_size(0x04)
$C$DW$T$11	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$11, DW_AT_encoding(DW_ATE_unsigned)
	.dwattr $C$DW$T$11, DW_AT_name("unsigned int")
	.dwattr $C$DW$T$11, DW_AT_byte_size(0x04)
$C$DW$T$32	.dwtag  DW_TAG_typedef, DW_AT_name("uint32_t")
	.dwattr $C$DW$T$32, DW_AT_type(*$C$DW$T$11)
	.dwattr $C$DW$T$32, DW_AT_language(DW_LANG_C)
	.dwattr $C$DW$T$32, DW_AT_decl_file("/usr/share/ti/cgt-pru/include/stdint.h")
	.dwattr $C$DW$T$32, DW_AT_decl_line(0x2f)
	.dwattr $C$DW$T$32, DW_AT_decl_column(0x1c)

$C$DW$T$33	.dwtag  DW_TAG_array_type
	.dwattr $C$DW$T$33, DW_AT_type(*$C$DW$T$32)
	.dwattr $C$DW$T$33, DW_AT_language(DW_LANG_C)
	.dwattr $C$DW$T$33, DW_AT_byte_size(0x04)
$C$DW$181	.dwtag  DW_TAG_subrange_type
	.dwattr $C$DW$181, DW_AT_upper_bound(0x00)
	.dwendtag $C$DW$T$33


$C$DW$T$34	.dwtag  DW_TAG_array_type
	.dwattr $C$DW$T$34, DW_AT_type(*$C$DW$T$32)
	.dwattr $C$DW$T$34, DW_AT_language(DW_LANG_C)
	.dwattr $C$DW$T$34, DW_AT_byte_size(0x08)
$C$DW$182	.dwtag  DW_TAG_subrange_type
	.dwattr $C$DW$182, DW_AT_upper_bound(0x01)
	.dwendtag $C$DW$T$34


$C$DW$T$45	.dwtag  DW_TAG_array_type
	.dwattr $C$DW$T$45, DW_AT_type(*$C$DW$T$32)
	.dwattr $C$DW$T$45, DW_AT_language(DW_LANG_C)
	.dwattr $C$DW$T$45, DW_AT_byte_size(0x0c)
$C$DW$183	.dwtag  DW_TAG_subrange_type
	.dwattr $C$DW$183, DW_AT_upper_bound(0x02)
	.dwendtag $C$DW$T$45

$C$DW$T$47	.dwtag  DW_TAG_volatile_type
	.dwattr $C$DW$T$47, DW_AT_type(*$C$DW$T$32)
$C$DW$T$12	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$12, DW_AT_encoding(DW_ATE_signed)
	.dwattr $C$DW$T$12, DW_AT_name("long")
	.dwattr $C$DW$T$12, DW_AT_byte_size(0x04)
$C$DW$T$13	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$13, DW_AT_encoding(DW_ATE_unsigned)
	.dwattr $C$DW$T$13, DW_AT_name("unsigned long")
	.dwattr $C$DW$T$13, DW_AT_byte_size(0x04)
$C$DW$T$14	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$14, DW_AT_encoding(DW_ATE_signed)
	.dwattr $C$DW$T$14, DW_AT_name("long long")
	.dwattr $C$DW$T$14, DW_AT_byte_size(0x08)
$C$DW$T$15	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$15, DW_AT_encoding(DW_ATE_unsigned)
	.dwattr $C$DW$T$15, DW_AT_name("unsigned long long")
	.dwattr $C$DW$T$15, DW_AT_byte_size(0x08)
$C$DW$T$16	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$16, DW_AT_encoding(DW_ATE_float)
	.dwattr $C$DW$T$16, DW_AT_name("float")
	.dwattr $C$DW$T$16, DW_AT_byte_size(0x04)
$C$DW$T$17	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$17, DW_AT_encoding(DW_ATE_float)
	.dwattr $C$DW$T$17, DW_AT_name("double")
	.dwattr $C$DW$T$17, DW_AT_byte_size(0x08)
$C$DW$T$18	.dwtag  DW_TAG_base_type
	.dwattr $C$DW$T$18, DW_AT_encoding(DW_ATE_float)
	.dwattr $C$DW$T$18, DW_AT_name("long double")
	.dwattr $C$DW$T$18, DW_AT_byte_size(0x08)

$C$DW$T$92	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$92, DW_AT_name("my_resource_table")
	.dwattr $C$DW$T$92, DW_AT_byte_size(0x14)
$C$DW$184	.dwtag  DW_TAG_member
	.dwattr $C$DW$184, DW_AT_type(*$C$DW$T$93)
	.dwattr $C$DW$184, DW_AT_name("base")
	.dwattr $C$DW$184, DW_AT_TI_symbol_name("base")
	.dwattr $C$DW$184, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$184, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$184, DW_AT_decl_file("resource_table_pru1.h")
	.dwattr $C$DW$184, DW_AT_decl_line(0x39)
	.dwattr $C$DW$184, DW_AT_decl_column(0x18)
$C$DW$185	.dwtag  DW_TAG_member
	.dwattr $C$DW$185, DW_AT_type(*$C$DW$T$33)
	.dwattr $C$DW$185, DW_AT_name("offset")
	.dwattr $C$DW$185, DW_AT_TI_symbol_name("offset")
	.dwattr $C$DW$185, DW_AT_data_member_location[DW_OP_plus_uconst 0x10]
	.dwattr $C$DW$185, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$185, DW_AT_decl_file("resource_table_pru1.h")
	.dwattr $C$DW$185, DW_AT_decl_line(0x3b)
	.dwattr $C$DW$185, DW_AT_decl_column(0x0b)
	.dwendtag $C$DW$T$92

	.dwattr $C$DW$T$92, DW_AT_decl_file("resource_table_pru1.h")
	.dwattr $C$DW$T$92, DW_AT_decl_line(0x38)
	.dwattr $C$DW$T$92, DW_AT_decl_column(0x08)

$C$DW$T$93	.dwtag  DW_TAG_structure_type
	.dwattr $C$DW$T$93, DW_AT_name("resource_table")
	.dwattr $C$DW$T$93, DW_AT_byte_size(0x10)
$C$DW$186	.dwtag  DW_TAG_member
	.dwattr $C$DW$186, DW_AT_type(*$C$DW$T$32)
	.dwattr $C$DW$186, DW_AT_name("ver")
	.dwattr $C$DW$186, DW_AT_TI_symbol_name("ver")
	.dwattr $C$DW$186, DW_AT_data_member_location[DW_OP_plus_uconst 0x0]
	.dwattr $C$DW$186, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$186, DW_AT_decl_file("../../include/rsc_types.h")
	.dwattr $C$DW$186, DW_AT_decl_line(0x57)
	.dwattr $C$DW$186, DW_AT_decl_column(0x0b)
$C$DW$187	.dwtag  DW_TAG_member
	.dwattr $C$DW$187, DW_AT_type(*$C$DW$T$32)
	.dwattr $C$DW$187, DW_AT_name("num")
	.dwattr $C$DW$187, DW_AT_TI_symbol_name("num")
	.dwattr $C$DW$187, DW_AT_data_member_location[DW_OP_plus_uconst 0x4]
	.dwattr $C$DW$187, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$187, DW_AT_decl_file("../../include/rsc_types.h")
	.dwattr $C$DW$187, DW_AT_decl_line(0x58)
	.dwattr $C$DW$187, DW_AT_decl_column(0x0b)
$C$DW$188	.dwtag  DW_TAG_member
	.dwattr $C$DW$188, DW_AT_type(*$C$DW$T$34)
	.dwattr $C$DW$188, DW_AT_name("reserved")
	.dwattr $C$DW$188, DW_AT_TI_symbol_name("reserved")
	.dwattr $C$DW$188, DW_AT_data_member_location[DW_OP_plus_uconst 0x8]
	.dwattr $C$DW$188, DW_AT_accessibility(DW_ACCESS_public)
	.dwattr $C$DW$188, DW_AT_decl_file("../../include/rsc_types.h")
	.dwattr $C$DW$188, DW_AT_decl_line(0x59)
	.dwattr $C$DW$188, DW_AT_decl_column(0x0b)
	.dwendtag $C$DW$T$93

	.dwattr $C$DW$T$93, DW_AT_decl_file("../../include/rsc_types.h")
	.dwattr $C$DW$T$93, DW_AT_decl_line(0x56)
	.dwattr $C$DW$T$93, DW_AT_decl_column(0x08)
	.dwattr $C$DW$CU, DW_AT_language(DW_LANG_C)

;***************************************************************
;* DWARF CIE ENTRIES                                           *
;***************************************************************

$C$DW$CIE	.dwcie 14
	.dwcfi	cfa_register, 8
	.dwcfi	cfa_offset, 0
	.dwcfi	undefined, 0
	.dwcfi	undefined, 1
	.dwcfi	undefined, 2
	.dwcfi	undefined, 3
	.dwcfi	undefined, 4
	.dwcfi	undefined, 5
	.dwcfi	undefined, 6
	.dwcfi	undefined, 7
	.dwcfi	same_value, 8
	.dwcfi	same_value, 9
	.dwcfi	same_value, 10
	.dwcfi	same_value, 11
	.dwcfi	undefined, 12
	.dwcfi	undefined, 13
	.dwcfi	undefined, 14
	.dwcfi	undefined, 15
	.dwcfi	same_value, 16
	.dwcfi	same_value, 17
	.dwcfi	same_value, 18
	.dwcfi	same_value, 19
	.dwcfi	same_value, 20
	.dwcfi	same_value, 21
	.dwcfi	same_value, 22
	.dwcfi	same_value, 23
	.dwcfi	same_value, 24
	.dwcfi	same_value, 25
	.dwcfi	same_value, 26
	.dwcfi	same_value, 27
	.dwcfi	same_value, 28
	.dwcfi	same_value, 29
	.dwcfi	same_value, 30
	.dwcfi	same_value, 31
	.dwcfi	same_value, 32
	.dwcfi	same_value, 33
	.dwcfi	same_value, 34
	.dwcfi	same_value, 35
	.dwcfi	same_value, 36
	.dwcfi	same_value, 37
	.dwcfi	same_value, 38
	.dwcfi	same_value, 39
	.dwcfi	same_value, 40
	.dwcfi	same_value, 41
	.dwcfi	same_value, 42
	.dwcfi	same_value, 43
	.dwcfi	same_value, 44
	.dwcfi	same_value, 45
	.dwcfi	same_value, 46
	.dwcfi	same_value, 47
	.dwcfi	same_value, 48
	.dwcfi	same_value, 49
	.dwcfi	same_value, 50
	.dwcfi	same_value, 51
	.dwcfi	same_value, 52
	.dwcfi	same_value, 53
	.dwcfi	same_value, 54
	.dwcfi	same_value, 55
	.dwcfi	undefined, 56
	.dwcfi	undefined, 57
	.dwcfi	undefined, 58
	.dwcfi	undefined, 59
	.dwcfi	undefined, 60
	.dwcfi	undefined, 61
	.dwcfi	undefined, 62
	.dwcfi	undefined, 63
	.dwcfi	undefined, 64
	.dwcfi	undefined, 65
	.dwcfi	undefined, 66
	.dwcfi	undefined, 67
	.dwcfi	undefined, 68
	.dwcfi	undefined, 69
	.dwcfi	undefined, 70
	.dwcfi	undefined, 71
	.dwcfi	undefined, 72
	.dwcfi	undefined, 73
	.dwcfi	undefined, 74
	.dwcfi	undefined, 75
	.dwcfi	undefined, 76
	.dwcfi	undefined, 77
	.dwcfi	undefined, 78
	.dwcfi	undefined, 79
	.dwcfi	undefined, 80
	.dwcfi	undefined, 81
	.dwcfi	undefined, 82
	.dwcfi	undefined, 83
	.dwcfi	undefined, 84
	.dwcfi	undefined, 85
	.dwcfi	undefined, 86
	.dwcfi	undefined, 87
	.dwcfi	undefined, 88
	.dwcfi	undefined, 89
	.dwcfi	undefined, 90
	.dwcfi	undefined, 91
	.dwcfi	undefined, 92
	.dwcfi	undefined, 93
	.dwcfi	undefined, 94
	.dwcfi	undefined, 95
	.dwcfi	undefined, 96
	.dwcfi	undefined, 97
	.dwcfi	undefined, 98
	.dwcfi	undefined, 99
	.dwcfi	undefined, 100
	.dwcfi	undefined, 101
	.dwcfi	undefined, 102
	.dwcfi	undefined, 103
	.dwcfi	undefined, 104
	.dwcfi	undefined, 105
	.dwcfi	undefined, 106
	.dwcfi	undefined, 107
	.dwcfi	undefined, 108
	.dwcfi	undefined, 109
	.dwcfi	undefined, 110
	.dwcfi	undefined, 111
	.dwcfi	undefined, 112
	.dwcfi	undefined, 113
	.dwcfi	undefined, 114
	.dwcfi	undefined, 115
	.dwcfi	undefined, 116
	.dwcfi	undefined, 117
	.dwcfi	undefined, 118
	.dwcfi	undefined, 119
	.dwcfi	undefined, 120
	.dwcfi	undefined, 121
	.dwcfi	undefined, 122
	.dwcfi	undefined, 123
	.dwcfi	undefined, 124
	.dwcfi	undefined, 125
	.dwcfi	undefined, 126
	.dwcfi	undefined, 127
	.dwcfi	undefined, 128
	.dwcfi	undefined, 129
	.dwcfi	undefined, 130
	.dwcfi	undefined, 131
	.dwcfi	undefined, 132
	.dwcfi	undefined, 133
	.dwcfi	undefined, 134
	.dwendentry

;***************************************************************
;* DWARF REGISTER MAP                                          *
;***************************************************************

$C$DW$189	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R0_b0")
	.dwattr $C$DW$189, DW_AT_location[DW_OP_reg0]
$C$DW$190	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R0_b1")
	.dwattr $C$DW$190, DW_AT_location[DW_OP_reg1]
$C$DW$191	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R0_b2")
	.dwattr $C$DW$191, DW_AT_location[DW_OP_reg2]
$C$DW$192	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R0_b3")
	.dwattr $C$DW$192, DW_AT_location[DW_OP_reg3]
$C$DW$193	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R1_b0")
	.dwattr $C$DW$193, DW_AT_location[DW_OP_reg4]
$C$DW$194	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R1_b1")
	.dwattr $C$DW$194, DW_AT_location[DW_OP_reg5]
$C$DW$195	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R1_b2")
	.dwattr $C$DW$195, DW_AT_location[DW_OP_reg6]
$C$DW$196	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R1_b3")
	.dwattr $C$DW$196, DW_AT_location[DW_OP_reg7]
$C$DW$197	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R2_b0")
	.dwattr $C$DW$197, DW_AT_location[DW_OP_reg8]
$C$DW$198	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R2_b1")
	.dwattr $C$DW$198, DW_AT_location[DW_OP_reg9]
$C$DW$199	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R2_b2")
	.dwattr $C$DW$199, DW_AT_location[DW_OP_reg10]
$C$DW$200	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R2_b3")
	.dwattr $C$DW$200, DW_AT_location[DW_OP_reg11]
$C$DW$201	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R3_b0")
	.dwattr $C$DW$201, DW_AT_location[DW_OP_reg12]
$C$DW$202	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R3_b1")
	.dwattr $C$DW$202, DW_AT_location[DW_OP_reg13]
$C$DW$203	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R3_b2")
	.dwattr $C$DW$203, DW_AT_location[DW_OP_reg14]
$C$DW$204	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R3_b3")
	.dwattr $C$DW$204, DW_AT_location[DW_OP_reg15]
$C$DW$205	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R4_b0")
	.dwattr $C$DW$205, DW_AT_location[DW_OP_reg16]
$C$DW$206	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R4_b1")
	.dwattr $C$DW$206, DW_AT_location[DW_OP_reg17]
$C$DW$207	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R4_b2")
	.dwattr $C$DW$207, DW_AT_location[DW_OP_reg18]
$C$DW$208	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R4_b3")
	.dwattr $C$DW$208, DW_AT_location[DW_OP_reg19]
$C$DW$209	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R5_b0")
	.dwattr $C$DW$209, DW_AT_location[DW_OP_reg20]
$C$DW$210	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R5_b1")
	.dwattr $C$DW$210, DW_AT_location[DW_OP_reg21]
$C$DW$211	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R5_b2")
	.dwattr $C$DW$211, DW_AT_location[DW_OP_reg22]
$C$DW$212	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R5_b3")
	.dwattr $C$DW$212, DW_AT_location[DW_OP_reg23]
$C$DW$213	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R6_b0")
	.dwattr $C$DW$213, DW_AT_location[DW_OP_reg24]
$C$DW$214	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R6_b1")
	.dwattr $C$DW$214, DW_AT_location[DW_OP_reg25]
$C$DW$215	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R6_b2")
	.dwattr $C$DW$215, DW_AT_location[DW_OP_reg26]
$C$DW$216	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R6_b3")
	.dwattr $C$DW$216, DW_AT_location[DW_OP_reg27]
$C$DW$217	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R7_b0")
	.dwattr $C$DW$217, DW_AT_location[DW_OP_reg28]
$C$DW$218	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R7_b1")
	.dwattr $C$DW$218, DW_AT_location[DW_OP_reg29]
$C$DW$219	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R7_b2")
	.dwattr $C$DW$219, DW_AT_location[DW_OP_reg30]
$C$DW$220	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R7_b3")
	.dwattr $C$DW$220, DW_AT_location[DW_OP_reg31]
$C$DW$221	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R8_b0")
	.dwattr $C$DW$221, DW_AT_location[DW_OP_regx 0x20]
$C$DW$222	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R8_b1")
	.dwattr $C$DW$222, DW_AT_location[DW_OP_regx 0x21]
$C$DW$223	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R8_b2")
	.dwattr $C$DW$223, DW_AT_location[DW_OP_regx 0x22]
$C$DW$224	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R8_b3")
	.dwattr $C$DW$224, DW_AT_location[DW_OP_regx 0x23]
$C$DW$225	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R9_b0")
	.dwattr $C$DW$225, DW_AT_location[DW_OP_regx 0x24]
$C$DW$226	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R9_b1")
	.dwattr $C$DW$226, DW_AT_location[DW_OP_regx 0x25]
$C$DW$227	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R9_b2")
	.dwattr $C$DW$227, DW_AT_location[DW_OP_regx 0x26]
$C$DW$228	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R9_b3")
	.dwattr $C$DW$228, DW_AT_location[DW_OP_regx 0x27]
$C$DW$229	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R10_b0")
	.dwattr $C$DW$229, DW_AT_location[DW_OP_regx 0x28]
$C$DW$230	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R10_b1")
	.dwattr $C$DW$230, DW_AT_location[DW_OP_regx 0x29]
$C$DW$231	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R10_b2")
	.dwattr $C$DW$231, DW_AT_location[DW_OP_regx 0x2a]
$C$DW$232	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R10_b3")
	.dwattr $C$DW$232, DW_AT_location[DW_OP_regx 0x2b]
$C$DW$233	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R11_b0")
	.dwattr $C$DW$233, DW_AT_location[DW_OP_regx 0x2c]
$C$DW$234	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R11_b1")
	.dwattr $C$DW$234, DW_AT_location[DW_OP_regx 0x2d]
$C$DW$235	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R11_b2")
	.dwattr $C$DW$235, DW_AT_location[DW_OP_regx 0x2e]
$C$DW$236	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R11_b3")
	.dwattr $C$DW$236, DW_AT_location[DW_OP_regx 0x2f]
$C$DW$237	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R12_b0")
	.dwattr $C$DW$237, DW_AT_location[DW_OP_regx 0x30]
$C$DW$238	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R12_b1")
	.dwattr $C$DW$238, DW_AT_location[DW_OP_regx 0x31]
$C$DW$239	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R12_b2")
	.dwattr $C$DW$239, DW_AT_location[DW_OP_regx 0x32]
$C$DW$240	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R12_b3")
	.dwattr $C$DW$240, DW_AT_location[DW_OP_regx 0x33]
$C$DW$241	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R13_b0")
	.dwattr $C$DW$241, DW_AT_location[DW_OP_regx 0x34]
$C$DW$242	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R13_b1")
	.dwattr $C$DW$242, DW_AT_location[DW_OP_regx 0x35]
$C$DW$243	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R13_b2")
	.dwattr $C$DW$243, DW_AT_location[DW_OP_regx 0x36]
$C$DW$244	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R13_b3")
	.dwattr $C$DW$244, DW_AT_location[DW_OP_regx 0x37]
$C$DW$245	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R14_b0")
	.dwattr $C$DW$245, DW_AT_location[DW_OP_regx 0x38]
$C$DW$246	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R14_b1")
	.dwattr $C$DW$246, DW_AT_location[DW_OP_regx 0x39]
$C$DW$247	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R14_b2")
	.dwattr $C$DW$247, DW_AT_location[DW_OP_regx 0x3a]
$C$DW$248	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R14_b3")
	.dwattr $C$DW$248, DW_AT_location[DW_OP_regx 0x3b]
$C$DW$249	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R15_b0")
	.dwattr $C$DW$249, DW_AT_location[DW_OP_regx 0x3c]
$C$DW$250	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R15_b1")
	.dwattr $C$DW$250, DW_AT_location[DW_OP_regx 0x3d]
$C$DW$251	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R15_b2")
	.dwattr $C$DW$251, DW_AT_location[DW_OP_regx 0x3e]
$C$DW$252	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R15_b3")
	.dwattr $C$DW$252, DW_AT_location[DW_OP_regx 0x3f]
$C$DW$253	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R16_b0")
	.dwattr $C$DW$253, DW_AT_location[DW_OP_regx 0x40]
$C$DW$254	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R16_b1")
	.dwattr $C$DW$254, DW_AT_location[DW_OP_regx 0x41]
$C$DW$255	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R16_b2")
	.dwattr $C$DW$255, DW_AT_location[DW_OP_regx 0x42]
$C$DW$256	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R16_b3")
	.dwattr $C$DW$256, DW_AT_location[DW_OP_regx 0x43]
$C$DW$257	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R17_b0")
	.dwattr $C$DW$257, DW_AT_location[DW_OP_regx 0x44]
$C$DW$258	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R17_b1")
	.dwattr $C$DW$258, DW_AT_location[DW_OP_regx 0x45]
$C$DW$259	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R17_b2")
	.dwattr $C$DW$259, DW_AT_location[DW_OP_regx 0x46]
$C$DW$260	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R17_b3")
	.dwattr $C$DW$260, DW_AT_location[DW_OP_regx 0x47]
$C$DW$261	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R18_b0")
	.dwattr $C$DW$261, DW_AT_location[DW_OP_regx 0x48]
$C$DW$262	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R18_b1")
	.dwattr $C$DW$262, DW_AT_location[DW_OP_regx 0x49]
$C$DW$263	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R18_b2")
	.dwattr $C$DW$263, DW_AT_location[DW_OP_regx 0x4a]
$C$DW$264	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R18_b3")
	.dwattr $C$DW$264, DW_AT_location[DW_OP_regx 0x4b]
$C$DW$265	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R19_b0")
	.dwattr $C$DW$265, DW_AT_location[DW_OP_regx 0x4c]
$C$DW$266	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R19_b1")
	.dwattr $C$DW$266, DW_AT_location[DW_OP_regx 0x4d]
$C$DW$267	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R19_b2")
	.dwattr $C$DW$267, DW_AT_location[DW_OP_regx 0x4e]
$C$DW$268	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R19_b3")
	.dwattr $C$DW$268, DW_AT_location[DW_OP_regx 0x4f]
$C$DW$269	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R20_b0")
	.dwattr $C$DW$269, DW_AT_location[DW_OP_regx 0x50]
$C$DW$270	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R20_b1")
	.dwattr $C$DW$270, DW_AT_location[DW_OP_regx 0x51]
$C$DW$271	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R20_b2")
	.dwattr $C$DW$271, DW_AT_location[DW_OP_regx 0x52]
$C$DW$272	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R20_b3")
	.dwattr $C$DW$272, DW_AT_location[DW_OP_regx 0x53]
$C$DW$273	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R21_b0")
	.dwattr $C$DW$273, DW_AT_location[DW_OP_regx 0x54]
$C$DW$274	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R21_b1")
	.dwattr $C$DW$274, DW_AT_location[DW_OP_regx 0x55]
$C$DW$275	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R21_b2")
	.dwattr $C$DW$275, DW_AT_location[DW_OP_regx 0x56]
$C$DW$276	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R21_b3")
	.dwattr $C$DW$276, DW_AT_location[DW_OP_regx 0x57]
$C$DW$277	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R22_b0")
	.dwattr $C$DW$277, DW_AT_location[DW_OP_regx 0x58]
$C$DW$278	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R22_b1")
	.dwattr $C$DW$278, DW_AT_location[DW_OP_regx 0x59]
$C$DW$279	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R22_b2")
	.dwattr $C$DW$279, DW_AT_location[DW_OP_regx 0x5a]
$C$DW$280	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R22_b3")
	.dwattr $C$DW$280, DW_AT_location[DW_OP_regx 0x5b]
$C$DW$281	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R23_b0")
	.dwattr $C$DW$281, DW_AT_location[DW_OP_regx 0x5c]
$C$DW$282	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R23_b1")
	.dwattr $C$DW$282, DW_AT_location[DW_OP_regx 0x5d]
$C$DW$283	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R23_b2")
	.dwattr $C$DW$283, DW_AT_location[DW_OP_regx 0x5e]
$C$DW$284	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R23_b3")
	.dwattr $C$DW$284, DW_AT_location[DW_OP_regx 0x5f]
$C$DW$285	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R24_b0")
	.dwattr $C$DW$285, DW_AT_location[DW_OP_regx 0x60]
$C$DW$286	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R24_b1")
	.dwattr $C$DW$286, DW_AT_location[DW_OP_regx 0x61]
$C$DW$287	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R24_b2")
	.dwattr $C$DW$287, DW_AT_location[DW_OP_regx 0x62]
$C$DW$288	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R24_b3")
	.dwattr $C$DW$288, DW_AT_location[DW_OP_regx 0x63]
$C$DW$289	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R25_b0")
	.dwattr $C$DW$289, DW_AT_location[DW_OP_regx 0x64]
$C$DW$290	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R25_b1")
	.dwattr $C$DW$290, DW_AT_location[DW_OP_regx 0x65]
$C$DW$291	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R25_b2")
	.dwattr $C$DW$291, DW_AT_location[DW_OP_regx 0x66]
$C$DW$292	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R25_b3")
	.dwattr $C$DW$292, DW_AT_location[DW_OP_regx 0x67]
$C$DW$293	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R26_b0")
	.dwattr $C$DW$293, DW_AT_location[DW_OP_regx 0x68]
$C$DW$294	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R26_b1")
	.dwattr $C$DW$294, DW_AT_location[DW_OP_regx 0x69]
$C$DW$295	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R26_b2")
	.dwattr $C$DW$295, DW_AT_location[DW_OP_regx 0x6a]
$C$DW$296	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R26_b3")
	.dwattr $C$DW$296, DW_AT_location[DW_OP_regx 0x6b]
$C$DW$297	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R27_b0")
	.dwattr $C$DW$297, DW_AT_location[DW_OP_regx 0x6c]
$C$DW$298	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R27_b1")
	.dwattr $C$DW$298, DW_AT_location[DW_OP_regx 0x6d]
$C$DW$299	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R27_b2")
	.dwattr $C$DW$299, DW_AT_location[DW_OP_regx 0x6e]
$C$DW$300	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R27_b3")
	.dwattr $C$DW$300, DW_AT_location[DW_OP_regx 0x6f]
$C$DW$301	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R28_b0")
	.dwattr $C$DW$301, DW_AT_location[DW_OP_regx 0x70]
$C$DW$302	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R28_b1")
	.dwattr $C$DW$302, DW_AT_location[DW_OP_regx 0x71]
$C$DW$303	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R28_b2")
	.dwattr $C$DW$303, DW_AT_location[DW_OP_regx 0x72]
$C$DW$304	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R28_b3")
	.dwattr $C$DW$304, DW_AT_location[DW_OP_regx 0x73]
$C$DW$305	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R29_b0")
	.dwattr $C$DW$305, DW_AT_location[DW_OP_regx 0x74]
$C$DW$306	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R29_b1")
	.dwattr $C$DW$306, DW_AT_location[DW_OP_regx 0x75]
$C$DW$307	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R29_b2")
	.dwattr $C$DW$307, DW_AT_location[DW_OP_regx 0x76]
$C$DW$308	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R29_b3")
	.dwattr $C$DW$308, DW_AT_location[DW_OP_regx 0x77]
$C$DW$309	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R30_b0")
	.dwattr $C$DW$309, DW_AT_location[DW_OP_regx 0x78]
$C$DW$310	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R30_b1")
	.dwattr $C$DW$310, DW_AT_location[DW_OP_regx 0x79]
$C$DW$311	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R30_b2")
	.dwattr $C$DW$311, DW_AT_location[DW_OP_regx 0x7a]
$C$DW$312	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R30_b3")
	.dwattr $C$DW$312, DW_AT_location[DW_OP_regx 0x7b]
$C$DW$313	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R31_b0")
	.dwattr $C$DW$313, DW_AT_location[DW_OP_regx 0x7c]
$C$DW$314	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R31_b1")
	.dwattr $C$DW$314, DW_AT_location[DW_OP_regx 0x7d]
$C$DW$315	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R31_b2")
	.dwattr $C$DW$315, DW_AT_location[DW_OP_regx 0x7e]
$C$DW$316	.dwtag  DW_TAG_TI_assign_register, DW_AT_name("R31_b3")
	.dwattr $C$DW$316, DW_AT_location[DW_OP_regx 0x7f]
	.dwendtag $C$DW$CU

