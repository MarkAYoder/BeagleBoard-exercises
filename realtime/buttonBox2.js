setTargetAddress('192.168.7.2', {
    initialized: run
});

setTargetAddress('10.8.7.185', {
    initialized: run
});

function run() {
    b = require('bonescript');
    var samples = 100,
        plotTop,
        // plotBot,
        ainData = [],  iain = 0, 
        gpioData = [], igpio = 0,
        gpioNum = "P9_42",   // GPIO pins to plot
        ainNum  = "P9_36";   // Analog ins to plot
    ainData [samples] = 0;
    gpioData[samples] = 0;
    
    b.pinMode(gpioNum, b.INPUT);

    // When new data arrived, convert it and plot it.
    
    // Request data every updateInterval ms
    function updateTop() {
        b.analogRead (ainNum,  ainPlot);
        b.digitalRead(gpioNum, gpioPlot);
        setTimeout(updateTop, updateTopInterval);
    }
    updateTop();

    // function updateBot() {
    //     // socket.emit("i2c",  i2cNum);
    //     setTimeout(updateBot, updateBotInterval);
    // }
    // updateBot();    
    
    function gpioPlot(data) {
        gpioData[igpio] = [igpio, data.value];
        igpio++;
        if(igpio >= samples) {
            igpio = 0;
            gpioData = [];
        }
        plotTop.setData([ ainData, gpioData ]);
        plotTop.draw();
    }

    function ainPlot(data) {
        // status_update("ainPlot: " + data.value);
        ainData[iain] = [iain, data.value];
        iain++;
        if(iain >= samples) {
            iain = 0;
            ainData = [];
        }
        plotTop.setData([ ainData, gpioData ]);
        plotTop.draw();
    }

    function status_update(txt){
    //   document.getElementById('status').innerHTML = txt
    $('#status').html(txt);
    }

    function initPlotData() {
        // zip the generated y values with the x values
        var result = [];
        for (var i = 0; i <= samples; i++)
            result[i] = [i, 0];
        return result;
    }

    // setup control widget
    $("#ainNum").val(ainNum).change(function () {
        ainNum = $(this).val();
    });

    $("#gpioNum").val(gpioNum).change(function () {
        gpioNum = $(this).val();
    });

    $("#slider1").slider({min:0, max:100, slide: function(event, ui) {
// 	socket.emit("slider",  1, ui.value/100);
    }});

    var updateTopInterval = 100;
    $("#updateTopInterval").val(updateTopInterval).change(function () {
        var v = $(this).val();
        if (v && !isNaN(+v)) {
            updateTopInterval = +v;
            if (updateTopInterval < 25)
                updateTopInterval = 25;
            if (updateTopInterval > 2000)
                updateTopInterval = 2000;
            $(this).val("" + updateTopInterval);
        }
    });

    var updateBotInterval = 100;
    $("#updateBotInterval").val(updateBotInterval).change(function () {
        var v = $(this).val();
        if (v && !isNaN(+v)) {
            updateBotInterval = +v;
            if (updateBotInterval < 25)
                updateBotInterval = 25;
            if (updateBotInterval > 2000)
                updateBotInterval = 2000;
            $(this).val("" + updateBotInterval);
        }
    });

    // setup plot
    var optionsTop = {
        series: { 
            shadowSize: 0, // drawing is faster without shadows
            points: { show: false},
            lines:  { show: true, lineWidth: 5}
        }, 
        yaxis:	{ min: 0, max: 2, 
                  zoomRange: [10, 256], panRange: [-128, 128] },
        xaxis:	{ show: true, 
                  zoomRange: [10, 100], panRange: [0, 100] },
        legend:	{ position: "ne" },
        zoom:	{ interactive: true, amount: 1.1 },
        pan:	{ interactive: true }
    };
    plotTop = $.plot($("#plotTop"), 
        [ 
          { data:  initPlotData(), 
            label: "Analog In" },
          { data:  initPlotData(),
            label: "gpio in" }
        ],
            optionsTop);

    var optionsBot = {
        series: { 
            shadowSize: 0, // drawing is faster without shadows
            points: { show: false},
            lines:  { show: true, lineWidth: 5},
            color: 2
        }, 
        yaxis:	{ min: 60, max: 80, 
                  zoomRange: [10, 256], panRange: [60, 100] },
        xaxis:	{ show: true, 
                  zoomRange: [10, 100], panRange: [0, 100] },
        legend:	{ position: "ne" },
        zoom:	{ interactive: true, amount: 1.1 },
        pan:	{ interactive: true }
    };
    // plotBot = $.plot($("#plotBot"), 
    //     [ 
    //       { data:  initPlotData(),
    //         label: "i2c"}
    //     ],
    //         optionsBot);

}

var fs = require('fs');
function doTrigger(arg) {
    var ledPath = "/sys/class/leds/beaglebone:green:usr";
console.log("trigger: " + arg);
    arg = arg.split(" ");
    for(var i=0; i<4; i++) {
    console.log(" trigger: ", arg[i]);
        fs.writeFile(ledPath + i + "/trigger", arg[i]);
    }
}

function trigger(trig) {
console.log('trigger: ' + trig);
    if(trig) {
        doTrigger("heartbeat mmc0 cpu0 none");
    } else {
        doTrigger("none none none none");
    }
}