// This example is from http://www.youtube.com/watch?v=hQVTIJBZook, 27:52 minutes in
// JavaScript: The Good Parts

var digit_name = (function () {
    "use strict";
    var names = ['zero', 'one', 'two', 'three', 'four',
	    'five', 'six', 'seven', 'eight', 'nine'];

    return function (n) {
        return names[n];
    };
}());

console.log(digit_name(3));

