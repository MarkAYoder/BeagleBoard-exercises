#!/usr/bin/env node

// From: https://firebase.google.com/docs/database/web/start
// Click Add Firebase to your web app.
// Note the initialization code snippet, which you will use in a minute.
// This will fill in the configuration data.
// npm install firebase --save

const firebase = require('firebase');
// console.log(firebase);

  // Set the configuration for your app
  // TODO: Replace with your project's config object
  // Initialize Firebase
  var config = {
    apiKey: "AIzaSyA38ZowvXCmArjhqwxY9AUUhXX-VtGs72I",
    authDomain: "curious-kingdom-800.firebaseapp.com",
    databaseURL: "https://curious-kingdom-800.firebaseio.com",
    storageBucket: "curious-kingdom-800.appspot.com",
    messagingSenderId: "754426251062"
  };
  firebase.initializeApp(config);

  // Get a reference to the database service
  var database = firebase.database();

//   console.log(database);

// This does seem to work
var userId = 'userid0';
firebase.database().ref('/users/' + userId).once('value').then(function(snapshot) {
  var username = snapshot.val();
  console.log(username);
});

function writeUserData(userId, name, email, imageUrl) {
  firebase.database().ref('users3/' + userId).set({
    username: name,
    email: email,
    profile_picture : imageUrl
  });
}

// for(var i=0; i<2; i++) {
//     console.log(i);
//     writeUserData('userId'+i, 'name ' + i, 'email', 'imageUrl');
// }

console.log(firebase.auth());

console.log("Done");
