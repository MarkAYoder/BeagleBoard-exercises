#!/usr/bin/env node
// From https://github.com/sandeepmistry/node-sensortag
// Install:
// apt-get install libbluetooth-dev bluez
// npm install -g sensortag
// hcitool lescan
// export BLE=90:59:AF:0B:84:57
//hcitool lecc $BLE

// Reads temperature

var util = require('util');

var async = require('async');

var SensorTag = require('sensortag');

var demoNumber = 0;
var maxDemo = 6;

SensorTag.discover(function(sensorTag) {
  console.log('sensorTag = ' + sensorTag);
  sensorTag.on('disconnect', function() {
    console.log('disconnected!');
    process.exit(0);
  });

  async.series([
      function(callback) {
        console.log('connect');
        sensorTag.connect(callback);
      },
      function(callback) {
        console.log('discoverServicesAndCharacteristics');
        sensorTag.discoverServicesAndCharacteristics(callback);
      },
      function(callback) {
        console.log('enableIrTemperature');
        sensorTag.enableIrTemperature(callback);
      },
      function(callback) {
        setTimeout(callback, 1000);
      },
      function(callback) {
        console.log('readIrTemperature');
        sensorTag.readIrTemperature(function(objectTemperature, ambientTemperature) {
          console.log('\tobject temperature = %d °C', objectTemperature.toFixed(1));
          console.log('\tambient temperature = %d °C', ambientTemperature.toFixed(1));

          callback();
        });

        // sensorTag.on('irTemperatureChange', function(objectTemperature, ambientTemperature) {
        //   console.log('\tobject temperature = %d °C', objectTemperature.toFixed(1));
        //   console.log('\tambient temperature = %d °C', ambientTemperature.toFixed(1))
        // });

        // sensorTag.notifyIrTemperature(function() {
        //   console.log('notifyIrTemperature');
        // });
      },
      function(callback) {
        console.log('disableIrTemperature');
        sensorTag.disableAccelerometer(callback);
      },
      function(callback) {
        console.log('enableAccelerometer');
        sensorTag.enableAccelerometer(callback);
      },
      function(callback) {
        setTimeout(callback, 1000);
      },
      function(callback) {
        console.log('readAccelerometer');
        sensorTag.readAccelerometer(function(x, y, z) {
          console.log('\tx = %d G', x.toFixed(1));
          console.log('\ty = %d G', y.toFixed(1));
          console.log('\tz = %d G', z.toFixed(1));

          callback();
        });

        sensorTag.on('accelerometerChange', function(x, y, z) {
          console.log('\tx = %d G', x.toFixed(1));
          console.log('\ty = %d G', y.toFixed(1));
          console.log('\tz = %d G', z.toFixed(1));
        });

        sensorTag.notifyAccelerometer(function() {

        });
      },
      function(callback) {
        console.log('readSimpleRead');
        sensorTag.on('simpleKeyChange', function(left, right) {
          console.log('left: ' + left);
          console.log('right: ' + right);

          if (left) {
            demoNumber++;
            if(demoNumber > maxDemo) {
              demoNumber = 0;
            }
          }
          if(right) {
            demoNumber--;
            if(demoNumber<0) {
              demoNumber = maxDemo;
            }
          }
          console.log('demoNumber = ' + demoNumber);
          if (left && right) {
            sensorTag.notifySimpleKey(callback);
          }
        });

        sensorTag.notifySimpleKey(function() {

        });
      },
      function(callback) {
        console.log('disconnect');
        sensorTag.disconnect(callback);
      }
    ]
  );
});
