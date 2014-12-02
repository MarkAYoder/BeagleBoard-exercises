#!/usr/bin/env node

console.log(process.env.WOLFRAM_APPID);

var wolfram = require('./node-wolfram').createClient(process.env.WOLFRAM_APPID)

wolfram.query({search: "words containing msdoep", 
  options:
    "&podstate=WordsMadeWithOnlyLetters__Show+all" +
    "&podstate=WordsMadeWithOnlyLetters__Disallow+repetition" +
    "&includepodid=WordsMadeWithOnlyLetters"}, 
    function(err, result) {
	if(err) throw err
	console.log("Size: %d", result.length);
	console.log("Result: %j", result[0].subpods[0].value);
})

wolfram.query("words containing abcdefg", 
    function(err, result) {
	if(err) throw err
	console.log("Size: %d", result.length);
	console.log("Result: %j", result);
})
