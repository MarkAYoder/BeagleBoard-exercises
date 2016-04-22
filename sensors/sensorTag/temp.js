#!/usr/bin/env node

var util = require('util');
var async = require('async');
var SensorTag = require('./index');

var USE_READ = false;
var sampleTime = 1000;  // time in ms between readings
var testTime  = 10000;  // time in ms to run each test

SensorTag.discover(function(sensorTag) {
  console.log('discovered: ' + sensorTag);

  sensorTag.on('disconnect', function() {
    console.log('disconnected!');
    process.exit(0);
  });

  async.series([
      function(callback) {
        console.log('connectAndSetUp');
        sensorTag.connectAndSetUp(callback);
      },
      function(callback) {
        console.log('enableIrTemperature');
        sensorTag.enableIrTemperature(callback);
      },
      function(callback) {
        setTimeout(callback, 2000);
      },
      function(callback) {
        if (USE_READ) {
          console.log('readIrTemperature');
          sensorTag.readIrTemperature(function(error, objectTemperature, ambientTemperature) {
            console.log('\tobject temperature = %d °C', objectTemperature.toFixed(1));
            console.log('\tambient temperature = %d °C', ambientTemperature.toFixed(1));

            callback();
          });
        } else {
          sensorTag.on('irTemperatureChange', function(objectTemperature, ambientTemperature) {
            console.log('\tobject temperature = %d °C', objectTemperature.toFixed(1));
            console.log('\tambient temperature = %d °C', ambientTemperature.toFixed(1))
          });

          console.log('setIrTemperaturePeriod');
          sensorTag.setIrTemperaturePeriod(sampleTime, function(error) {
            console.log('notifyIrTemperature');
            sensorTag.notifyIrTemperature(function(error) {
              setTimeout(function() {
                console.log('unnotifyIrTemperature');
                sensorTag.unnotifyIrTemperature(callback);
              }, testTime);
            });
          });
        }
      },
      function(callback) {
        console.log('disableIrTemperature');
        sensorTag.disableIrTemperature(callback);
      },
      function(callback) {
        console.log('enableHumidity');
        sensorTag.enableHumidity(callback);
      },
      function(callback) {
        setTimeout(callback, 2000);
      },
      function(callback) {
        if (USE_READ) {
          console.log('readHumidity');
          sensorTag.readHumidity(function(error, temperature, humidity) {
            console.log('\ttemperature = %d °C', temperature.toFixed(1));
            console.log('\thumidity = %d %', humidity.toFixed(1));

            callback();
          });
        } else {
          sensorTag.on('humidityChange', function(temperature, humidity) {
            console.log('\ttemperature = %d °C', temperature.toFixed(1));
            console.log('\thumidity = %d %', humidity.toFixed(1));
          });

          console.log('setHumidityPeriod');
          sensorTag.setHumidityPeriod(sampleTime, function(error) {
            console.log('notifyHumidity');
            sensorTag.notifyHumidity(function(error) {
              setTimeout(function() {
                console.log('unnotifyHumidity');
                sensorTag.unnotifyHumidity(callback);
              }, testTime);
            });
          });
        }
      },
      function(callback) {
        console.log('disableHumidity');
        sensorTag.disableHumidity(callback);
      },
      function(callback) {
        console.log('enableBarometricPressure');
        sensorTag.enableBarometricPressure(callback);
      },
      function(callback) {
        setTimeout(callback, 2000);
      },
      function(callback) {
        if (USE_READ) {
          console.log('readBarometricPressure');
          sensorTag.readBarometricPressure(function(error, pressure) {
            console.log('\tpressure = %d mBar', pressure.toFixed(1));

            callback();
          });
        } else {
          sensorTag.on('barometricPressureChange', function(pressure) {
            console.log('\tpressure = %d mBar', pressure.toFixed(1));
          });

          console.log('setBarometricPressurePeriod');
          sensorTag.setBarometricPressurePeriod(sampleTime, function(error) {
            console.log('notifyBarometricPressure');
            sensorTag.notifyBarometricPressure(function(error) {
              setTimeout(function() {
                console.log('unnotifyBarometricPressure');
                sensorTag.unnotifyBarometricPressure(callback);
              }, testTime);
            });
          });
        }
      },
      function(callback) {
        console.log('disableBarometricPressure');
        sensorTag.disableBarometricPressure(callback);
      },
      function(callback) {
        if (sensorTag.type === 'cc2540') {

        } else if (sensorTag.type === 'cc2650') {
          async.series([
            function(callback) {
              console.log('enableLuxometer');
              sensorTag.enableLuxometer(callback);
            },
            function(callback) {
              setTimeout(callback, 2000);
            },
            function(callback) {
              if (USE_READ) {
                console.log('readLuxometer');
                sensorTag.readLuxometer(function(error, lux) {
                  console.log('\tlux = %d', lux.toFixed(1));

                  callback();
                });
              } else {
                sensorTag.on('luxometerChange', function(lux) {
                  console.log('\tlux = %d', lux.toFixed(1));
                });

                console.log('setLuxometer');
                sensorTag.setLuxometerPeriod(sampleTime, function(error) {
                  console.log('notifyLuxometer');
                  sensorTag.notifyLuxometer(function(error) {
                    setTimeout(function() {
                      console.log('unnotifyLuxometer');
                      sensorTag.unnotifyLuxometer(callback);
                    }, testTime);
                  });
                });
              }
            },
            function(callback) {
              console.log('disableLuxometer');
              sensorTag.disableLuxometer(callback);
            },
            function() {
              callback();
            }
          ]);
        } else {
          callback();
        }
      },
      function(callback) {
        console.log('disconnect');
        sensorTag.disconnect(callback);
      }
    ]
  );
});
