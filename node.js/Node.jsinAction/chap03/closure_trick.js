function asyncFunction(callback) {
    "use strict";
    setTimeout(function () {
        callback();
    }, 200);
}

var color = 'blue';

(function (color) {
    "use strict";
    asyncFunction(function () {
        console.log('The color is ' + color);
    });
}(color));

color = 'green';

