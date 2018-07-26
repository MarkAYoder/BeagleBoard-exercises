#!/usr/bin/env node
// From: https://developers.google.com/sheets/api/quickstart/nodejs#step_3_set_up_the_sample
const BMP085  = require('bmp085');
const fs = require('fs');
const util = require('util');
const readline = require('readline');
const {google} = require('googleapis');

const sheetID = '1GZPqjOIEZiOsgyKBMQ7HJg2G8iRbT1ArVUrYmReLhUI';
const ms = 15*1000;          // Repeat time

const barometer = new BMP085({device: '/dev/i2c-2', mode: '2'});

// If modifying these scopes, delete credentials.json.
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];
const TOKEN_PATH = 'token.json';

var authGlobal;

// Load client secrets from a local file.
fs.readFile('credentials.json', (err, content) => {
  if (err) return console.log('Error loading client secret file:', err);
  // Authorize a client with credentials, then call the Google Sheets API.
  authorize(JSON.parse(content), readWeather);
});

/**
 * Create an OAuth2 client with the given credentials, and then execute the
 * given callback function.
 * @param {Object} credentials The authorization client credentials.
 * @param {function} callback The callback to call with the authorized client.
 */
function authorize(credentials, callback) {
  const {client_secret, client_id, redirect_uris} = credentials.installed;
  const oAuth2Client = new google.auth.OAuth2(
      client_id, client_secret, redirect_uris[0]);

  // Check if we have previously stored a token.
  fs.readFile(TOKEN_PATH, (err, token) => {
    if (err) return getNewToken(oAuth2Client, callback);
    oAuth2Client.setCredentials(JSON.parse(token));
    callback(oAuth2Client);
  });
}

/**
 * Get and store new token after prompting for user authorization, and then
 * execute the given callback with the authorized OAuth2 client.
 * @param {google.auth.OAuth2} oAuth2Client The OAuth2 client to get token for.
 * @param {getEventsCallback} callback The callback for the authorized client.
 */
function getNewToken(oAuth2Client, callback) {
  const authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SCOPES,
  });
  console.log('Authorize this app by visiting this url:', authUrl);
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });
  rl.question('Enter the code from that page here: ', (code) => {
    rl.close();
    oAuth2Client.getToken(code, (err, token) => {
      if (err) return callback(err);
      oAuth2Client.setCredentials(token);
      // Store the token to disk for later program executions
      fs.writeFile(TOKEN_PATH, JSON.stringify(token), (err) => {
        if (err) console.error(err);
        console.log('Token stored to', TOKEN_PATH);
      });
      callback(oAuth2Client);
    });
  });
}

function readWeather(auth) {
    authGlobal = auth;
    barometer.read(postTemp);
}

var tempOld = NaN;
var pressOld = NaN;

function postTemp(data) {
  var auth = authGlobal;
  setTimeout(readWeather, ms, auth);

  // console.log("auth: " + auth);
  const sheets = google.sheets({version: 'v4', auth});
  var date = new Date();

  console.log("data: " + util.inspect(data));
  const temp = data.temperature*9/5+32;
  const pressure = data.pressure.toFixed(1)>950?NaN:data.pressure.toFixed(1);

  // logger.debug("temp: " + temp);
  // logger.debug("pressure: " + pressure);
  console.log("temp: " + temp);
  console.log("pressure: " + pressure);

  if(temp !== tempOld) {
    console.log("Updating from: " + tempOld + " " + pressOld);

    sheets.spreadsheets.values.append({
      spreadsheetId: sheetID,
      range: 'A2',
      // How the input data should be interpreted.
      valueInputOption: 'USER_ENTERED',
      // How the input data should be inserted.
      insertDataOption: 'INSERT_ROWS', 
      resource: {
        values: [   // getTime returs ms.  Convert to days.  25569 is date(1910,1,1), adjust for EST
            [
              date.getTime()/1000/60/60/24 + 25569 - 4/24,
              temp,
              pressure
            ]
          ]
      },
    }, (err, res) => {
      if (err) return console.log('The API returned an error: ' + err);
      console.log("res: " + util.inspect(res.data.tableRange));
    });
    
    tempOld  = temp;
    pressOld = pressure;
  }

}
