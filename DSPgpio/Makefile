# This is a work in progress
# Be sure to 
#    $ cd ~/exercises/c6run_build/
#    $ ./loadmodules.sh
#    $ source environment.sh

# *****************************************************************
#
# LAB05ABC Makefile (Starter makefile)
#
# Uses the following variables (built-in and user-defined):
#
# CC = C compiler (gcc)
# CFLAGS = compiler options (e.g. -g)
# LINKER_FLAGS = specify libraries to link in
# $@ = target
# $^ = all dependencies
# $< = first dependency only (not used in this solution)
#
# GCC options used in this makefile:
#
# -c = "compile only"
# -o = "output filename"
# -g = "debug mode"
#
# ***************************************************************
# --------------------------------
# ------ user-defined vars -------
# --------------------------------
# CC := $(LINUXarm_GCC)
# CFLAGS := -g
# LINKER_FLAGS := -lstdc++
C6RUNAPP := /opt/toolchains/c6run_binary/bin/c6runapp-cc 

# -----------------------
# ------ make all -------
# -----------------------

# The "all" rule commonly specifies all executable targets to
# be built. Note, the user has full control over what the "all"
# rule builds. In this solution, we only have one target.
# However, in the final DaVinci makefile, you'll see more
# targets listed. 
.PHONY : all
all:	readPushbuttonViaDSP

# -----------------------------------
# ------ executable rule (.x) -------
# -----------------------------------
readPushbuttonViaDSP:	readPushbuttonViaDSP.c
	$(C6RUNAPP) $(LINKER_FLAGS) $< -o $@
	@echo; echo $@ successfully created; echo

# ---------------------------------------------------
# ------ intermeditate object files rule (.o) -------
# ---------------------------------------------------
%.o :	%.c
	$(CC) $(CFLAGS) -c $< -o $@

# ----------------------
# ----- clean all ------
# ----------------------

# The "clean" rule should remove all files created by
# the makefile (e.g. the executables and intermediate
# files).
.PHONY :	clean
clean:
	rm -rf readPushbuttonViaDSP.o readPushbuttonViaDSP

# -------------------------------------
# ----- basic debug for makefile ------
#
# -----     example only         ------
# -------------------------------------

# We use test to print out the user-defined variables to
# make sure they are set properly - this helps with 
# debugging makefile errors.
.PHONY : test
test:
	@echo CC = $(CC)
	@echo CFLAGS = $(CFLAGS)
	@echo LINUXarm_GCC = $(LINUXarm_GCC)
	@echo LINKER_FLAGS  = $(LINKER_FLAGS)
	@echo C6RUNAPP = $(C6RUNAPP)

