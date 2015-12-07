#!/usr/bin/env node
// Testing winston for logging
var winston = require('winston');

var logger = new winston.Logger({
    transports: [
        new winston.transports.File({
            level: 'debug',
            filename: 'weather.log',
            handleExceptions: true,
            json: true,
            maxsize: 1024000, //5MB
            maxFiles: 5
        }),
        new winston.transports.Console({
            level: 'info',
            handleExceptions: true,
            json: false,
            colorize: true
        })
    ],
    exitOnError: false
});

logger.log('info', 'Hello distributed log files!');
logger.info('Hello again distributed logs');
logger.debug('Hello again and again');
