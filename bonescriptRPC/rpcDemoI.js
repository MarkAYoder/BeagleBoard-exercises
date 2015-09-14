// This uses the BeagleBone's remote procecdure call (RPC) to poll an
// analog input and attache an interrupt to a switch.  
// From: http://jsfiddle.net/2fnj3wLg/

setTargetAddress('192.168.7.2', {
    initialized: run
});

setTargetAddress('10.8.7.185', {
    initialized: run
});

var SLIDER = 'P9_36';
var BUTTON = 'P9_42';
var LED    = 'P9_14';
var FADE   = 'P9_16';
var toggle = true;          // State of LED

var ms     = 200;           // Polling interval in ms

function led(x) {
    console.log("led called with: %d, toggle: ", x, toggle);
    b.digitalWrite(LED, toggle);
    toggle = !toggle;
}

function fade(x) {
    // console.log("fade: %s", JSON.stringify(x))
    b.analogWrite(FADE, x);
}

function run() {
    b = require('bonescript');
    b.pinMode(BUTTON, b.INPUT );
    b.pinMode(LED,    b.OUTPUT);
    b.pinMode(FADE,   b.ANALOG_OUTPUT);
    
    initFade = 0.5;
    b.analogWrite(FADE, initFade);

    setInterval(getSliderStatus, ms);
    b.detachInterrupt(BUTTON);         // The detaches the interrupt from the previous run
    b.attachInterrupt(BUTTON, true, b.CHANGE, getButtonStatus);

    function getSliderStatus() {
        b.analogRead(SLIDER, onSliderRead);
    }

    function onSliderRead(x) {
        if (!x.err) {
            $('#sliderStatus').html(x.value.toFixed(3));
        }
    }

    function getButtonStatus() {
        b.digitalRead(BUTTON, onButtonRead);
    }

    function onButtonRead(x) {
        if (!x.err) {
            $('#buttonStatus').html(x.value);
        }
    }

    $(function () {
        $("#slider1").slider({min:0, max:100, value: 100*initFade, slide: function(event, ui) {
    	   // console.log("slider: %d",  ui.value);
    	    fade(ui.value/100);
        }});
    });
}
