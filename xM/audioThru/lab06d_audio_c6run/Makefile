#############################################################################
# Makefile                                                                  #
#                                                                           #
# Builds the audio thru source for ARM and DSP                              #
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
#   Name of the ARM GCC cross compiler & archiver
#   ----------------------------------------------------------------------------
ARM_TOOLCHAIN_PREFIX  ?= arm-none-linux-gnueabi-
ifdef ARM_TOOLCHAIN_PATH
ARM_CC := $(ARM_TOOLCHAIN_PATH)/bin/$(ARM_TOOLCHAIN_PREFIX)gcc
ARM_AR := $(ARM_TOOLCHAIN_PATH)/bin/$(ARM_TOOLCHAIN_PREFIX)ar
else
ARM_CC := $(ARM_TOOLCHAIN_PREFIX)gcc
ARM_AR := $(ARM_CROSS_COMPILE)ar
endif

# Get any compiler flags from the environmentre
ARM_CFLAGS = $(CFLAGS)
ARM_CFLAGS += -std=gnu99 \
-Wdeclaration-after-statement -Wall -Wno-trigraphs \
-fno-strict-aliasing -fno-common -fno-omit-frame-pointer \
-D_DEBUG_ \
-c -O3
ARM_LDFLAGS = $(LDFLAGS)
ARM_LDFLAGS+=-lm -lpthread -lasound
ARM_ARFLAGS = rcs

#   ----------------------------------------------------------------------------
#   Name of the DSP C6RUN compiler & archiver
#   TI C6RunLib Frontend (if path variable provided, use it, otherwise assume 
#   the tools are in the path)
#   ----------------------------------------------------------------------------
C6RUN_TOOLCHAIN_PREFIX=c6runlib-
ifdef C6RUN_TOOLCHAIN_PATH
C6RUN_CC := $(C6RUN_TOOLCHAIN_PATH)/bin/$(C6RUN_TOOLCHAIN_PREFIX)cc
C6RUN_AR := $(C6RUN_TOOLCHAIN_PATH)/bin/$(C6RUN_TOOLCHAIN_PREFIX)ar
else
C6RUN_CC := $(C6RUN_TOOLCHAIN_PREFIX)cc
C6RUN_AR := $(C6RUN_TOOLCHAIN_PREFIX)ar
endif

C6RUN_CFLAGS = -c -O3 -D_DEBUG_
C6RUN_ARFLAGS = rcs --C6Run:replace_malloc


#   ----------------------------------------------------------------------------
#   List of source files
#   ----------------------------------------------------------------------------
# List the files to run on the ARM here
EXEC_SRCS := main.c audio_input_output.c audio_thread.c 
EXEC_ARM_OBJS := $(EXEC_SRCS:%.c=gpp/%.o)
EXEC_DSP_OBJS := $(EXEC_SRCS:%.c=dsp/%.o)

# List the files to run on the DSP here
LIB_SRCS := audio_process.c
LIB_ARM_OBJS := $(LIB_SRCS:%.c=gpp_lib/%.o)
LIB_DSP_OBJS := $(LIB_SRCS:%.c=dsp_lib/%.o)

#   ----------------------------------------------------------------------------
#   Makefile targets
#   ----------------------------------------------------------------------------
.PHONY : dsp_exec gpp_exec dsp_lib gpp_lib dsp_clean gpp_clean all clean

all: gpp_exec dsp_exec
clean: gpp_clean dsp_clean

#   ----------------------------------------------------------------------------
#   Rules for build and ARM (gpp) only target 
#   ----------------------------------------------------------------------------
gpp_exec: gpp/.created gpp_lib $(EXEC_ARM_OBJS)
	$(ARM_CC) $(ARM_LDFLAGS) $(CINCLUDES) -o audioThru_arm $(EXEC_ARM_OBJS) \
			audioThru_arm.lib

gpp_lib: gpp_lib/.created $(LIB_ARM_OBJS)
	$(ARM_AR) $(ARM_ARFLAGS) audioThru_arm.lib $(LIB_ARM_OBJS)

gpp/%.o : %.c
	$(ARM_CC) $(ARM_CFLAGS) $(CINCLUDES) -o $@ $<
  
gpp_lib/%.o : %.c
	$(ARM_CC) $(ARM_CFLAGS) $(CINCLUDES) -o $@ $<

gpp/.created:
	@mkdir -p gpp
	@touch gpp/.created
  
gpp_lib/.created:
	@mkdir -p gpp_lib
	@touch gpp_lib/.created
  
gpp_clean:
	@rm -Rf audioThru_arm audioThru_arm.lib
	@rm -Rf gpp gpp_lib

#   ----------------------------------------------------------------------------
#   Rules for build and ARM/DSP (dsp) target 
#   ----------------------------------------------------------------------------
dsp_exec: dsp/.created dsp_lib $(EXEC_DSP_OBJS)
	$(ARM_CC) $(ARM_LDFLAGS) $(CINCLUDES) -o audioThru_dsp $(EXEC_DSP_OBJS) \
			audioThru_dsp.lib
	@echo "=================="
	@echo "Built for:"
	@echo "  ARM: $(EXEC_SRCS)"
	@echo "  DSP: $(LIB_SRCS)"
	@echo "=================="

dsp_lib: dsp_lib/.created $(LIB_DSP_OBJS)
	$(C6RUN_AR) $(C6RUN_ARFLAGS) audioThru_dsp.lib $(LIB_DSP_OBJS)

dsp/%.o : %.c
	$(ARM_CC) $(ARM_CFLAGS) $(CINCLUDES) -o $@ $<
  
dsp_lib/%.o : %.c
	$(C6RUN_CC) $(C6RUN_CFLAGS) $(CINCLUDES) -o $@ $<

dsp/.created:
	@mkdir -p dsp
	@touch dsp/.created

dsp_lib/.created:
	@mkdir -p dsp_lib
	@touch dsp_lib/.created

dsp_clean:
	@rm -Rf audioThru_dsp audioThru_dsp.lib
	@rm -Rf dsp dsp_lib

install:
	scp audioThru_arm audioThru_dsp root@beagle4:AudioThru/lab06d_audio_c6run/.

# *****************************************************************************
#
#    Additional Debug Information
#
# *****************************************************************************
#  Prints out build & variable definitions
# ----------------------------------------
#  - While not exhaustive, these commands print out a number of
#    variables created by gMake, or within this script
#  - Can be useful information when debugging script errors
#  - As described in the 2nd warning below, set DUMP=1 on the command
#    line to have this debug info printed out for you
#  - The $(warning ) gMake function is used for this rule; this allows
#    almost anything to be printed out - in our case, variables
# ---------------------------------------------------------------------

ifdef DUMP
#  $(warning To view build commands, invoke make with argument 'AT= ')
  $(warning To view build variables, invoke make with 'DUMP=1')

  $(warning ARM_CC:      $(ARM_CC))
  $(warning ARM_AR:      $(ARM_AR))
  $(warning ARM_CFLAGS:  $(ARM_CFLAGS))
  $(warning ARM_LDFLAGS: $(ARM_LDFLAGS))
  $(warning ARM_ARFLAGS: $(ARM_ARFLAGS))

  $(warning C6RUN_CC:      $(C6RUN_CC))
  $(warning C6RUN_AR:      $(C6RUN_AR))
  $(warning C6RUN_CFLAGS:  $(C6RUN_CFLAGS))
  $(warning C6RUN_ARFLAGS: $(C6RUN_ARFLAGS))

  $(warning EXEC_DSP_OBJS: $(EXEC_DSP_OBJS))


endif


