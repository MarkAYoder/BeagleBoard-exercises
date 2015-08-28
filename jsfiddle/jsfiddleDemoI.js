// This uses the BeagleBone's remote procecdure call (RPC) to poll an
// analog input and attache an interrupt to a switch.  
// From: http://jsfiddle.net/2fnj3wLg/

setTargetAddress('192.168.7.2', {
    initialized: run
});

var SLIDER = 'P9_36';
var BUTTON = 'P9_42';
var LED   = 'P9_14';
var toggle = true;          // State of LED

var ms     = 200;           // Polling interval in ms

function led(x) {
    console.log("led called with: %d, toggle: ", x, toggle);
    b.digitalWrite(LED, toggle);
    toggle = !toggle;
}

function run() {
    b = require('bonescript');
    b.pinMode(BUTTON, b.INPUT );
    b.pinMode(LED,    b.OUTPUT);

    setInterval(getSliderStatus, ms);
    b.detachInterrupt(BUTTON);         // The detaches the interrupt from the previous run
    b.attachInterrupt(BUTTON, true, b.CHANGE, getButtonStatus);

    function getSliderStatus() {
        b.analogRead(SLIDER, onSliderRead);     // <5>
    }

    function onSliderRead(x) {
        if (!x.err) {                           // <6>
            $('#sliderStatus').html(x.value.toFixed(3));
        }
    }

    function getButtonStatus() {
        b.digitalRead(BUTTON, onButtonRead);    // <8>
    }

    function onButtonRead(x) {
        if (!x.err) {                           // <9>
            $('#buttonStatus').html(x.value);
        }
    }
}
