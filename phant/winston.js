#!/usr/bin/env node
// Testing winston for logging
var winston = require('winston');

winston.add(winston.transports.File, { filename: 'somefile.log' });

winston.log('info', 'Hello distributed log files!');
winston.info('Hello again distributed logs');