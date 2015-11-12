/*
 *   debug.h
 *
 * ============================================================================
 * Copyright (c) Texas Instruments Inc 2005
 *
 * Use of this software is controlled by the terms and conditions found in the
 * license agreement under which this software has been supplied or provided.
 * ============================================================================
 */

#include <stdio.h>

// Enables or disables debug output
#ifdef _DEBUG_
    #define DBG(fmt, args...) fprintf(stderr, "Debug: " fmt, ## args)
    #define dspTraceDump(ce) Engine_fwriteTrace((ce), "[DSP] ", stderr)
#else
    #define DBG(fmt, args...)
    #define dspTraceDump(ce)
#endif

#define ERR(fmt, args...) fprintf(stderr, "Error: " fmt, ## args)

