#############################################################################
# Makefile                                                                  #
#                                                                           #
# Builds the emqbit benchmark source for ARM and DSP                        #
#############################################################################
#
#
#############################################################################
#                                                                           #
#   Copyright (C) 2010 Texas Instruments Incorporated                       #
#     http://www.ti.com/                                                    #
#                                                                           #
#############################################################################
#
#
#############################################################################
#                                                                           #
#  Redistribution and use in source and binary forms, with or without       #
#  modification, are permitted provided that the following conditions       #
#  are met:                                                                 #
#                                                                           #
#    Redistributions of source code must retain the above copyright         #
#    notice, this list of conditions and the following disclaimer.          #
#                                                                           #
#    Redistributions in binary form must reproduce the above copyright      #
#    notice, this list of conditions and the following disclaimer in the    #
#    documentation and/or other materials provided with the                 #
#    distribution.                                                          #
#                                                                           #
#    Neither the name of Texas Instruments Incorporated nor the names of    #
#    its contributors may be used to endorse or promote products derived    #
#    from this software without specific prior written permission.          #
#                                                                           #
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS      #
#  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT        #
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR    #
#  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT     #
#  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,    #
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT         #
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,    #
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY    #
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT      #
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE    #
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.     #
#                                                                           #
#############################################################################


#   ----------------------------------------------------------------------------
#   Name of the ARM GCC cross compiler
#   ----------------------------------------------------------------------------
#ARM_TOOLCHAIN_PREFIX  ?= arm-angstrom-linux-gnueabi-
#ARM_TOOLCHAIN_PATH = /home/beagle/BeagleBoard/oe/build/tmp-angstrom_v2012_05-eglibc/sysroots/x86_64-linux/usr/bin/armv7a-angstrom-linux-gnueabi
ifdef ARM_TOOLCHAIN_PATH
ARM_CC := $(ARM_TOOLCHAIN_PATH)/$(ARM_TOOLCHAIN_PREFIX)gcc
else
ARM_CC := $(ARM_TOOLCHAIN_PREFIX)gcc
endif

# Pick up any ARM compiler and linker flags from the environment
ARM_CFLAGS = $(CFLAGS) -ggdb3
ARM_CFLAGS += -std=gnu99 \
-Wdeclaration-after-statement -Wall -Wno-trigraphs \
-fno-strict-aliasing -fno-common -fno-omit-frame-pointer \
-c -O3
ARM_LDFLAGS = $(LDFLAGS)
ARM_LDFLAGS+=-lm


#   ----------------------------------------------------------------------------
#   Name of the DSP compiler
#   TI C6RunApp Frontend (if path variable provided, use it, otherwise assume 
#   the tools are in the path)
#   ----------------------------------------------------------------------------
C6RUN_TOOLCHAIN_PREFIX=c6runapp-
ifdef C6RUN_TOOLCHAIN_PATH
C6RUN_CC := $(C6RUN_TOOLCHAIN_PATH)/bin/$(C6RUN_TOOLCHAIN_PREFIX)cc
else
C6RUN_CC := $(C6RUN_TOOLCHAIN_PREFIX)cc
endif

C6RUN_CFLAGS = -c -O3
C6RUN_LDFLAGS=


#   ----------------------------------------------------------------------------
#   List of source files
#   ----------------------------------------------------------------------------
SRCS := main_cfft.c main_bench.c cfft.c distance.c
ARM_OBJS := $(SRCS:%.c=gpp/%.o)
DSP_OBJS := $(SRCS:%.c=dsp/%.o)

#   ----------------------------------------------------------------------------
#   Makefile targets
#   ----------------------------------------------------------------------------
.PHONY : dsp gpp dsp_clean gpp_clean all clean

# all: dsp gpp
all: gpp
clean: dsp_clean gpp_clean


gpp: gpp/.created $(ARM_OBJS)
	$(ARM_CC) $(ARM_LDFLAGS) -o bench_arm  gpp/main_bench.o gpp/distance.o 
	$(ARM_CC) $(ARM_LDFLAGS) -o cfft_arm gpp/main_cfft.o gpp/cfft.o

gpp/%.o : %.c
	$(ARM_CC) $(ARM_CFLAGS) $(CINCLUDES) -o $@ $<

gpp/.created:
	@mkdir -p gpp
	@touch gpp/.created
  
gpp_clean:
	@rm -Rf bench_arm cfft_arm cfft_x86
	@rm -Rf gpp


dsp: dsp/.created $(DSP_OBJS)
	$(C6RUN_CC) $(C6RUN_LDFLAGS) -o bench_dsp dsp/main_bench.o dsp/distance.o 
	$(C6RUN_CC) $(C6RUN_LDFLAGS) -o cfft_dsp dsp/main_cfft.o dsp/cfft.o 

dsp/%.o : %.c
	$(C6RUN_CC) $(C6RUN_CFLAGS) $(CINCLUDES) -o $@ $<

dsp/.created:
	@mkdir -p dsp
	@touch dsp/.created

install:
	scp *_arm root@beagle:exercises/gdbExample

x86:
	gcc -g -lm main_cfft.c cfft.c -o cfft_x86

dsp_clean:
	@rm -Rf bench_dsp cfft_dsp
	@rm -Rf dsp
