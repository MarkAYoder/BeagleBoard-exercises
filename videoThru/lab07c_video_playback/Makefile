# ********************************************************************************
#
# makefile     Version 1.0        Date: SEPT-29-2008
#
# Revisions:
# - (v0.80) First "standard" GNU makefile for DaVinci Workshop
#           used in workshop versions 1.30 (beta's 1 & 2)
# - (v1.00) Used for DaVinci Workshop (production version 1.30)
#
# Use:
# - This is the PARENT makefile to makefile_profile.mak. You can specify any
#   profile (i.e. release, debug, all) and it will pass this profile to the child
#   and run gMake with the proper options.
# - Invoke this file with a target called "help" to get more information
#   (i.e. "make help")
#
# ********************************************************************************


# ----------------------------------------------------------------------
# -----------------          Local Variables          ------------------
# ----------------------------------------------------------------------

# ---------------------------------------------------------------------
# AT: Used for debug purposes, it hides commands for a prettier output.
#     When debugging, you may want to set this to nothing.
# ---------------------------------------------------------------------
  AT := @

# ---------------------------------------------------------------------
# ---------    INSTALL: See description from 'help' below    ----------
# ---------------------------------------------------------------------
ifeq ($(filter install,$(MAKECMDGOALS)),install)
  INSTALL := install
else
  INSTALL := 
endif

# ---------------------------------------------------------------------
# -----------------             Rules            ----------------------
# ---------------------------------------------------------------------
.PHONY  : all debug release clean install help

all     : debug release

ifeq ($(MAKECMDGOALS),install)
  install : debug release
	@echo "Install was called without other targets, so both 'debug' and 'release' were built"
else
  install : 
	@echo 
endif

debug   : 
	@echo ; echo "Building 'debug' profile by calling:  make -f makefile_profile.mak PROFILE=DEBUG" ; echo
	$(AT) make -f makefile_profile.mak $(INSTALL) PROFILE=DEBUG | grep -v -F make[1]
	@       echo "Done building 'debug'"   ; echo

release : 
	@echo ; echo "Building 'release' profile by calling:  make -f makefile_profile.mak PROFILE=RELEASE" ; echo
	$(AT) make -f makefile_profile.mak $(INSTALL) PROFILE=RELEASE | grep -v -F make[1]
	@       echo "Done building 'release'" ; echo

clean   : 
	@echo ; echo "--------- Cleaning up files for $(firstword $(MAKEFILE_LIST)) ---------------------"
	$(AT) make -f makefile_profile.mak clean PROFILE=DEBUG   | grep -v -F make[1]
	$(AT) make -f makefile_profile.mak clean PROFILE=RELEASE | grep -v -F make[1]

help	:
	@echo
	@echo "This makefile serves as a 'parent' (or master) makefile. That is, it calls another makefile        "
	@echo "called 'makefile_profile.mak'. If the child makefile is called directly, it will build only        "
	@echo "one profile (by default, it builds the 'DEBUG' profile). This parent makefile allows               "
	@echo "you to easily build for multiple profiles with a single invocation.                                "
	@echo 
	@echo "The goals allowed by this makefile are:  all, debug, release, clean, install, help                 "
	@echo 
	@echo "     debug:  calls the child makefile with the "DEBUG" profile                                     "
	@echo "   release:  calls the child makefile with the "RELEASE" profile                                   "
	@echo "       all:  calls the child makefile twice, once with "DEBUG", then with "RELEASE"                "
	@echo "     clean:  calls the child makefile twice to clean both debug and release                        "
	@echo "   install:  adds the 'install' goal to the child makefile's target, then calls child. Install     "
	@echo "             will make BOTH profiles (release and debug) and install them to the DVEVM             "
	@echo
	@echo
	@echo "One other tip we've used here is to precede each command with $(AT). Then, we set AT=@. In this    "
	@echo "way, we don't usually have to see the actual command syntax -- that is, it makes our output        "
	@echo "look prettier. If, for debug reasons, you want to see the commands printed out, you can just add   " 
	@echo "'AT= ' to the makefile command -- like this:                                                       "
	@echo 
	@echo "              make debug AT=                                                                       "
	@echo
	@echo "Your value for AT then overrides the default, and the commands will be displayed. Of course, you   "
	@echo "can accomplish the same thing by just editing this makefile, setting AT=                           "
	@echo
	@echo "To DUMP additonal makefile variables, use 'DUMP=1' when you run make.                              "
	@echo

