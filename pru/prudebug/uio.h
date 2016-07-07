/* 
 *
 *  PRU Debug Program - UIO routine header file
 *  (c) Copyright 2011,2013 by Arctica Technologies
 *  Written by Steven Anderson
 *
 */

#ifndef H_UIO
#define H_UIO

#define UIO_MAX_UIO_FILEPATH	100		// maximum length of the path and name for a uio file (ex. /sys/class/uio/uio7/name)
#define UIO_MAX_DEV_NAME	50


struct uiomap {
	unsigned long		address;
	unsigned long		length;
};

struct uiodev {
	char			*uio_file;
	char			*name;
	char			*version;
	struct uiomap		*maps;
};


// prototypes
int uio_getprussfile(char *devname);

#endif

