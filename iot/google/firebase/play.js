#!/usr/bin/env node
// From: https://firebase.google.com/docs/database/web/start
// Never got authorization to work.

var firebase = require("firebase");
var util = require('util');

// Initialize Firebase
var config = {
    apiKey: "AIzaSyDaMwP3HNH52o2JWC4Nb8ZNHpdb0k0pn6s",
    authDomain: "friendlychat-c7ea7.firebaseapp.com",
    databaseURL: "https://friendlychat-c7ea7.firebaseio.com",
    storageBucket: "friendlychat-c7ea7.appspot.com",
    messagingSenderId: "513104136282"
};
firebase.initializeApp(config);

console.log("Getting provider");
var provider = new firebase.auth.GoogleAuthProvider();

console.log("Authorizing");

firebase.auth().signInWithPopup(provider).then(function(result) {
  // This gives you a Google Access Token. You can use it to access the Google API.
  console.log("result: " + util.inspect(result));
  
  var token = result.credential.accessToken;
  // The signed-in user info.
  var user = result.user;
  // ...
}).catch(function(error) {
  // Handle Errors here.
  var errorCode = error.code;
  var errorMessage = error.message;
  // The email of the user's account used.
  var email = error.email;
  // The firebase.auth.AuthCredential type that was used.
  var credential = error.credential;
  // ...
});

// firebase.database().ref('users/' + 'play').set({
//     username: 'Mark',
//     email: 'yoder@rose-hulman.edu'
// });

firebase.database().ref('users/' + 'play').push({
    username: 'Mark3',
    email: 'yoder@rose-hulman.edu'
});


// var read = firebase.database().ref('/users').once('value').then(function(snapshot) {
//   console.log("snapshot: " + util.inspect(snapshot));
// });

// console.log("read: " + util.inspect(read));
