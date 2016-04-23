#!/usr/bin/env node
// This does everything all at once.

var async = require('async');
var SensorTag = require('./index');
var request   = require('request');
var fs        = require('fs');
var util      = require('util');

var filename = "/root/exercises/sensors/sensorTag/keys_sensorTag.json";
var keys = JSON.parse(fs.readFileSync(filename));
var urlBase = keys.inputUrl + "/?private_key=" + keys.privateKey 
      + "&humidity=%s&pressure=%s&tempobj=%s&tempamb=%s&lux=%s";

var USE_READ = false;
var sampleTime = 5*1000;  // time in ms between readings

SensorTag.discover(function(sensorTag) {
  console.log('discovered: ' + sensorTag);
  var data = {tempObj:NaN, tempAmb:NaN, pressure:NaN, humidity:NaN, lux:NaN};

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
    sensorTag.unnotifyBarometricPressure();
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
          setInterval(function () {
              sensorTag.readIrTemperature( function(err, objectTemperature, ambientTemperature) {
              data.tempAmb = ambientTemperature;
              data.tempObj = objectTemperature;
              checkAll();
            })}, sampleTime);
          // console.log('setIrTemperaturePeriod');
          // sensorTag.setIrTemperaturePeriod(sampleTime, function(error) {
          //   console.log('notifyIrTemperature');
          //   sensorTag.notifyIrTemperature();
          // });
          
          sensorTag.on('humidityChange', function(temperature, humidity) {
            data.humidity = humidity;
            checkAll();
          });
          console.log('setHumidityPeriod');
          sensorTag.setHumidityPeriod(sampleTime, function(error) {
            console.log('notifyHumidity');
            sensorTag.notifyHumidity();
          });

          sensorTag.on('barometricPressureChange', function(pressure) {
            data.pressure = pressure;
            checkAll();
          });
          console.log('setBarometricPressurePeriod');
          sensorTag.setBarometricPressurePeriod(sampleTime, function(error) {
            console.log('notifyBarometricPressure');
            sensorTag.notifyBarometricPressure();
          });

        if (sensorTag.type === 'cc2540') {

        } else if (sensorTag.type === 'cc2650') {
                sensorTag.on('luxometerChange', function(lux) {
                  data.lux = lux;
                  checkAll();
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

  function checkAll() {
    console.log(data);
    var wait = false;
    for(var key in data) {
      if(isNaN(data[key])) {
        wait = true;    // All these data isn't here
      }
    }
    if(!wait) {
      console.log("All here");
      console.log('\tobject temperature = %d °C', data.tempObj.toFixed(1));
      console.log('\tambient temperature = %d °C', data.tempAmb.toFixed(1));
      console.log('\thumidity = %d %', data.humidity.toFixed(1));
      console.log('\tpressure = %d mBar', data.pressure.toFixed(1));
      console.log('\tlux = %d', data.lux.toFixed(1));

      // var url = util.format(urlBase, data.humidity, data.pressure, // Fill in data
      //     data.tempObj, data.tempAmb, data.lux);
      // console.log("url: ", url);
      // request(url, {timeout: 10000}, function (error, response, body) {
      //     if (!error && response.statusCode == 200) {
      //         console.log(body); 
      //     } else {
      //         console.log("error=" + error + " response=" + JSON.stringify(response));
      //     }
      // });
    
      data = {tempObj:NaN, tempAmb:NaN, pressure:NaN, humidity:NaN, lux:NaN};
    }
  }

});