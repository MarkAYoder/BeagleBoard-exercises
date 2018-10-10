#!/usr/bin/env node
// From: https://developers.google.com/sheets/api/quickstart/nodejs#step_3_set_up_the_sample
const i2c     = require('i2c-bus');
const fs = require('fs');
const util = require('util');
const readline = require('readline');
const {google} = require('googleapis');

const sheetID = '1BX6R8GhUqUXCKMP2NbJWRahR7Y2RR_ycLzn1Y3z7f7A';
const ms = 15*1000;          // Repeat time

// Read the i2c temp sensors
const bus = 2;
const tmp101 = [0x48, 0x4a];
const sensor = i2c.openSync(bus);

// If modifying these scopes, delete credentials.json.
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];
const TOKEN_PATH = 'token.json';

// Load client secrets from a local file.
fs.readFile('credentials.json', (err, content) => {
  if (err) return console.log('Error loading client secret file:', err);
  // Authorize a client with credentials, then call the Google Sheets API.
  authorize(JSON.parse(content), recordTemp);
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

/**
 * Prints the names and majors of students in a sample spreadsheet:
 * @see https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
 * @param {google.auth.OAuth2} auth The authenticated Google OAuth client.
 */

var tempOld = [];

function recordTemp(auth) {
  const sheets = google.sheets({version: 'v4', auth});
  setTimeout(recordTemp, ms, auth);
  var date = new Date();
  var temp = [];
    // Read the temp sensors
  for(var i=0; i<tmp101.length; i++) {
      // Convert from C to F
      temp[i] = sensor.readByteSync(tmp101[i], 0x0)*9/5+32;
      console.log("temp: %dF (0x%s)", temp[i], tmp101[i].toString(16));
  }

  if((temp[0] !== tempOld[0]) || (temp[1] !== tempOld[1])) {
    console.log("Updating from: " + tempOld[0] + " " + tempOld[1]);

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
              temp[0],
              temp[1]
            ]
          ]
      },
    }, (err, res) => {
      if (err) return console.log('The API returned an error: ' + err);
      console.log("res: " + util.inspect(res.data.tableRange));
    });
    
    tempOld[0] = temp[0];
    tempOld[1] = temp[1];
  }

}
