// From Page 36 of Node.js in Action
"use strict";
var canadianDollar = 0.91;

function roundTwoDecimals(amount) {
    return Math.round(amount * 100) / 100;
}

exports.canadianToUS = function (canadian) {
    return roundTwoDecimals(canadian * canadianDollar);
}

exports.USToCanadian = function (us) {
    return roundTwoDecimals(us / canadianDollar);
}

