# ***********************************************************************************
#
# makefile_profile.mak     Version 1.0        Date: SEPT-29-2008
#
# Revisions:
# - (v0.80) First "standard" GNU makefile for DaVinci Workshop
#           used in workshop versions 1.30 (beta's 1 & 2)
# - (v1.00) Used for DaVinci Workshop (production version 1.30)
# - (v2.00) Configuro removed, may 4-May-2011
# - (v2.01) Removed a bunch of unused stuff may 24-Aug-2011
#
# Use:
# - User can specify PROFILE (either debug
#   or release or all) when invoking the parent makefile
#   'make'  defaults to making DEBUG
#   'PROFILE=RELEASE make' makes the RELEASE version
# ***********************************************************************************

# *****************************************************************************
#
#    User-defined vars
#
# *****************************************************************************

# ---------------------------------------------------------------------
# AT: - Used for debug, it hides commands for a prettier output
#     - When debugging, you may want to set this variable to nothing by
#       setting it to "" below, or on the command line
# ---------------------------------------------------------------------
AT := @

# ---------------------------------------------------------------------
# Location and build option flags for gcc build tools
#   - CC is used to invoke gcc compiler
#   - CFLAGS, LINKER_FLAGS are generic gcc build options
#   - DEBUG/RELEASE FLAGS are profile specific options
# ---------------------------------------------------------------------
CC      :=  $gcc 

CFLAGS       := -Wall -fno-strict-aliasing -D_REENTRANT -march=armv7-a -lasound 
LINKER_FLAGS := -lpthread

DEBUG_CFLAGS   := -g -D_DEBUG_
RELEASE_CFLAGS := -O2

# ---------------------------------------------------------------------
# C_SRCS used to build two arrays:
#   - C_OBJS is used as dependencies for executable build rule 
#
# Three functions are used to create these arrays
#   - Wildcard
#   - Substitution
#   - Add prefix
# ---------------------------------------------------------------------
C_SRCS := $(wildcard *.c)

OBJS   := $(subst .c,.o,$(C_SRCS))
C_OBJS  = $(addprefix $(PROFILE)/,$(OBJS))

# ---------------------------------------------------------------------
# Project related variables
# -------------------------
#   PROGNAME defines the name of the program to be built
#   PROFILE: - defines which set of build flags to use (debug or release)
#            - output files are put into a $(PROFILE) subdirectory
#            - set to "debug" by default; override via the command line
# ---------------------------------------------------------------------
PROGNAME ?= app
PROFILE  ?= DEBUG

# -------------------------------------------------
# ----- always keep these intermediate files ------
# -------------------------------------------------
.PRECIOUS : $(C_OBJS)

# -------------------------------------------------
# --- delete the implicit rules for object files --
# -------------------------------------------------
%.o : %.c

# *****************************************************************************
#
#    Targets and Build Rules
#
# *****************************************************************************

# ---------------------------------------------------------------------
# 1. Build Executable Rule  (.x)
# ------------------------------
#  - For reading convenience, we called this rule #1
#  - The actual ARM executable to be built
#  - Built using the object files compiled from all the C files in 
#    the current directory
# ---------------------------------------------------------------------
$(PROGNAME)_$(PROFILE).Beagle : $(C_OBJS)
	@echo; echo "1.  ----- Need to generate executable file: $@ "
	$(AT) $(CC) $(CFLAGS) $(LINKER_FLAGS) $^ -o $@
	@echo "          Successfully created executable : $@ "


# ---------------------------------------------------------------------
# 2. Object File Rule (.o)
# ------------------------
#  - This was called rule #2
#  - Pattern matching rule builds .o file from it's associated .c file
#  - Since .o file is placed in $(PROFILE) directory, the rule includes
#    a command to make the directory, just in case it doesn't exist
# ---------------------------------------------------------------------
$(PROFILE)/%.o : %.c 
	@echo "2.  ----- Need to generate:      $@ (due to: $(wordlist 1,1,$?) ...)"
	$(AT) mkdir -p $(dir $@)
	$(AT) $(CC) $(CFLAGS) $($(PROFILE)_CFLAGS) -c $< -o $@
	@echo "          Successfully created:  $@ "

# *****************************************************************************
#
#    "Phony" Rules
#
# *****************************************************************************

# ---------------------------------------------------------------------
#  "all" Rule
# -----------
#   - Provided in case the a user calls the commonly found "all" target
#  - Called a Phony rule since the target (i.e. "all") doesn't exist
#    and shouldn't be searched for by gMake
# ---------------------------------------------------------------------
.PHONY  : all 
all : $(PROGNAME)_$(PROFILE).Beagle
	@echo ; echo "The target ($<) has been built." 
	@echo

# ---------------------------------------------------------------------
#  "clean" Rule
# -------------
#  - Cleans all files associated with the $(PROFILE) specified above or
#    via the command line
#  - Cleans the associated files in the containing folder
#  - Called a Phony rule since the target (i.e. "clean") doesn't exist
#    and shouldn't be searched for by gMake
# ---------------------------------------------------------------------
.PHONY : clean
clean  : 
	@echo ; echo "--------- Cleaning up files for $(PROFILE) -----"
	rm -rf $(PROFILE)
	rm -rf $(PROGNAME)_$(PROFILE).Beagle
	rm -rf $(C_OBJS)
	@echo

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
  $(warning To view build commands, invoke make with argument 'AT= ')
  $(warning To view build variables, invoke make with 'DUMP=1')

  $(warning Source Files: $(C_SRCS))
  $(warning Object Files: $(C_OBJS))

  $(warning Base program name : $(PROGNAME))
endif


