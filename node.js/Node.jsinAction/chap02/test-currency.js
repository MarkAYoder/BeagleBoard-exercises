//From page 37 of Node.js in Action

var currency = require('./currency'),
    index;

console.log('50 Canadian dollars equals this amount of US dollars:');
console.log(currency.canadianToUS(50));

console.log('30 US dollars equals this amount of Canadian dollars:');
console.log(currency.USToCanadian(30));

console.log('currency: ' + currency);
for (index in currency) {
    console.log(index);
}
