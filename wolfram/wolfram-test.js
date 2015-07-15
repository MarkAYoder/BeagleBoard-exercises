#!/usr/bin/env node

console.log(process.env.WOLFRAM_APPID);

var wolfram = require('wolfram').createClient(process.env.WOLFRAM_APPID)

wolfram.query("integrate 2x^3 + 3x^2", function(err, result) {
  if(err) throw err
  console.log("Result: %j", result)
})

// Try also sum_k=1^inf 1/k^2
