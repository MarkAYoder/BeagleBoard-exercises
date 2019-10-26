#!/usr/bin/env node
// From: https://developers.google.com/sheets/api/quickstart/nodejs#step_3_set_up_the_sample
const child_process = require('child_process');
const fs = require('fs');
const util = require('util');
const readline = require('readline');
const {google} = require('googleapis');

const sheetID = '1c8Qdph81ySof-2FkRSXIaajVXKNj2o6Abm1YnTz68h8';
const ms = 15*1000;          // Repeat time

// If modifying these scopes, delete credentials.json.
const SCOPES = ['https://www.googleapis.com/auth/spreadsheets'];
const TOKEN_PATH = 'token.json';

// Read site to ping from command line, or default to rose-hulman.edu
var ping = 'ping -c1 -i1 ';
if(process.argv.length > 2) {
    ping += process.argv[2];
} else {
    ping += "rose-hulman.edu";
}
console.log("Ping: %s", ping);

// Load client secrets from a local file.
fs.readFile('credentials.json', (err, content) => {
  if (err) return console.log('Error loading client secret file:', err);
  // Authorize a client with credentials, then call the Google Sheets API.
  authorize(JSON.parse(content), recordPing);
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

function recordPing(auth) {
  const sheets = google.sheets({ version: 'v4', auth });
  setTimeout(recordPing, ms, auth);

  child_process.exec(ping,
    function(error, stdout, stderr) {
      console.log('ping: ' + stdout);
      var time = [0]; // Report time=0 if an error.
      if (error || stderr) {
        console.log('error: ' + error);
        console.log('stderr: ' + stderr);
      }
      else {
        time = stdout.match(/time=[0-9.]* /mg); //  Pull the time out of the return string
        console.log("time: " + time);
        for (var i = 0; i < time.length; i++) {
          time[i] = time[i].substring(5, time[i].length-1); // Strip off the leading time= and trailing black
        }
      }

      console.log("time: \"" + time[0] + "\"");
      var date = new Date();

      sheets.spreadsheets.values.append({
        spreadsheetId: sheetID,
        range: 'A2',
        // How the input data should be interpreted.
        valueInputOption: 'USER_ENTERED',
        // How the input data should be inserted.
        insertDataOption: 'INSERT_ROWS',
        resource: {
          values: [ // getTime returs ms.  Convert to days.  25569 is date(1910,1,1), adjust for EST
            [
              date.getTime() / 1000 / 60 / 60 / 24 + 25569 - 4 / 24,
              time[0]
            ]
          ]
        },
      }, (err, res) => {
        if (err) return console.log('The API returned an error: ' + err);
        console.log("res: " + util.inspect(res.data.tableRange));
      });
    }
  );

}
