function asyncFunction(callback) {
    "use strict";
    setTimeout(function () {
        callback();
    }, 200);
}

var color = 'blue';

asyncFunction(function () {
    "use strict";
    console.log('The color is ' + color);
});

color = 'green';

