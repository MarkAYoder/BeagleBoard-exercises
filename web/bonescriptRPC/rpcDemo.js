// This uses the BeagleBone's remote procecdure call (RPC) to poll an
// analog input and a switch.  
// From: http://jsfiddle.net/2fnj3wLg/

setTargetAddress('192.168.7.2', {               // <1>
    initialized: run
});

setTargetAddress('10.8.7.185', {
    initialized: run
});

function run() {
    b = require('bonescript');              // <2>
    var SLIDER = 'P9_36';                       // <3>
    var BUTTON = 'P9_42';
    b.pinMode(BUTTON, b.INPUT);

    getSliderStatus();                          // <4>

    function getSliderStatus() {
        b.analogRead(SLIDER, onSliderRead);     // <5>
    }

    function onSliderRead(x) {
        if (!x.err) {                           // <6>
            $('#sliderStatus').html(x.value.toFixed(3));
        }
        getButtonStatus()                       // <7>
    }

    function getButtonStatus() {
        b.digitalRead(BUTTON, onButtonRead);    // <8>
    }

    function onButtonRead(x) {
        if (!x.err) {                           // <9>
            $('#buttonStatus').html(x.value);
        }
        setTimeout(getSliderStatus, 20);        // <10>
    }
}

var LED = 'P9_14';
var toggle = 1;

function led(x) {
    console.log("led called with: %d", x);
    b.digitalWrite(LED, toggle);
    toggle = !toggle;
}
