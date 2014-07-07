#!/bin/bash
# If the date is in the wrong year, correct it.
if ((`date +%Y` < 2013))
then
	ntpdate ntp.org
fi

