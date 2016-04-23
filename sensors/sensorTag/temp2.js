#!/usr/bin/env node
// This does everything all at once.

// var util = require('util');
var async = require('async');
var SensorTag = require('./index');

var USE_READ = false;
var sampleTime = 1000;  // time in ms between readings
var testTime  = 1000;  // time in ms to run each test

SensorTag.discover(function(sensorTag) {
  console.log('discovered: ' + sensorTag);

  sensorTag.on('disconnect', function() {
    console.log('disconnected!');
    process.exit(0);
  });
  
  process.on('SIGINT', function() {
    console.log('SIGINT');
    console.log('unnotifyIrTemperature');
    sensorTag.unnotifyIrTemperature();
    console.log('disableIrTemperature');
    sensorTag.disableIrTemperature();
    
    console.log('unnotifyHumidity');
    sensorTag.unnotifyHumidity();
    console.log('disableHumidity');
    sensorTag.disableHumidity();
    
    console.log('unnotifyBarometricPressure');
    sensorTag.unnotifyBarometricPressure()
    console.log('disableBarometricPressure');
    sensorTag.disableBarometricPressure();
    
    if (sensorTag.type === 'cc2650') {
      console.log('unnotifyLuxometer');
      sensorTag.unnotifyLuxometer();
      console.log('disableLuxometer');
      sensorTag.disableLuxometer();
    }
    sensorTag.disconnect();
  });

  async.series([
      function(callback) {
        console.log('connectAndSetUp');
        sensorTag.connectAndSetUp(callback);
      },
      function(callback) {
        console.log('enableIrTemperature');
        sensorTag.enableIrTemperature();
        
        console.log('enableHumidity');
        sensorTag.enableHumidity();
        
        console.log('enableBarometricPressure');
        sensorTag.enableBarometricPressure();
        
        if (sensorTag.type === 'cc2650') {
              console.log('enableLuxometer');
              sensorTag.enableLuxometer();
            }
        callback();
      },
      function(callback) {
          sensorTag.on('irTemperatureChange', function(objectTemperature, ambientTemperature) {
            console.log('\tobject temperature = %d °C', objectTemperature.toFixed(1));
            console.log('\tambient temperature = %d °C', ambientTemperature.toFixed(1))
          });
          console.log('setIrTemperaturePeriod');
          sensorTag.setIrTemperaturePeriod(sampleTime, function(error) {
            console.log('notifyIrTemperature');
            sensorTag.notifyIrTemperature();
          });
          
          sensorTag.on('humidityChange', function(temperature, humidity) {
            console.log('\ttemperature = %d °C', temperature.toFixed(1));
            console.log('\thumidity = %d %', humidity.toFixed(1));
          });
          console.log('setHumidityPeriod');
          sensorTag.setHumidityPeriod(sampleTime, function(error) {
            console.log('notifyHumidity');
            sensorTag.notifyHumidity();
          });

          sensorTag.on('barometricPressureChange', function(pressure) {
            console.log('\tpressure = %d mBar', pressure.toFixed(1));
          });
          console.log('setBarometricPressurePeriod');
          sensorTag.setBarometricPressurePeriod(sampleTime, function(error) {
            console.log('notifyBarometricPressure');
            sensorTag.notifyBarometricPressure();
          });

        if (sensorTag.type === 'cc2540') {

        } else if (sensorTag.type === 'cc2650') {
                sensorTag.on('luxometerChange', function(lux) {
                  console.log('\tlux = %d', lux.toFixed(1));
                });
                console.log('setLuxometerPeriod');
                sensorTag.setLuxometerPeriod(sampleTime, function(error) {
                  console.log('notifyLuxometer');
                  sensorTag.notifyLuxometer();
                });
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
