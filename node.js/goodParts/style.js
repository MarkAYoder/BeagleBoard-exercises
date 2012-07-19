// This example is from http://www.youtube.com/watch?v=hQVTIJBZook, 34:14 minutes in
// JavaScript: The Good Parts

var testLeft = function () {
        "use strict";
        return
        {
            ok: false
        };
    };

var testRight = function () {
        "use strict";
        return {
            ok: true
        };
    };

console.log(' testLeft() == ' + testLeft());
console.log('testright() == ' + testRight());

