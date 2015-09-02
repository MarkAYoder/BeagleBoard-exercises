    var socket;
    var firstconnect = true,
        samples = 100,
        plotTop,
        plotBot,
        ainData = [],  iain = 0, 
        gpioData = [], igpio = 0,
        i2cData = [],  ii2c = 0,
//        gpioNum = 7,
//        ainNum  = 6,
        gpioNum = ["P9_42"],   // GPIO pins to plot
        ainNum  = ["P9_35"],   // Analog ins to plot
        i2cNum  = "0x49";
    ainData[samples] = 0;
    gpioData[samples] = 0;
    i2cData[samples] = 0;

    function connect() {
      if(firstconnect) {
        socket = io.connect(null);

        socket.on('message', function(data)
            { status_update("Received: message");});
        socket.on('connect', function()
            { status_update("Connected to Server"); });
        socket.on('disconnect', function()
            { status_update("Disconnected from Server"); });
        socket.on('reconnect', function()
            { status_update("Reconnected to Server"); });
        socket.on('reconnecting', function( nextRetry )
            { status_update("Reconnecting in " + nextRetry/1000 + " s"); });
        socket.on('reconnect_failed', function()
            { message("Reconnect Failed"); });

        socket.on('ain',  ain);
        socket.on('gpio', gpio);
        socket.on('i2c',  i2c);

        firstconnect = false;
      }
      else {
        socket.socket.reconnect();
      }
    }

    function disconnect() {
      socket.disconnect();
    }

    function led(ledNum) {
        socket.emit('led', ledNum);
    }

    function trigger(trig) {
        socket.emit('trigger', trig);
    }

    // When new data arrived, convert it and plot it.
    
    function ain(data) {
//        status_update("ain: " + data.value);
        ainData[iain] = [iain, data.value];
        iain++;
        if(iain >= samples) {
            iain = 0;
            ainData = [];
        }
        plotTop.setData([ ainData, gpioData ]);
        plotTop.draw();
//        setTimeout(function(){socket.emit("ain", data.pin);}, updateTopInterval);
    }

    function gpio(data) {
        gpioData[igpio] = [igpio, data.value];
        igpio++;
        if(igpio >= samples) {
            igpio = 0;
            gpioData = [];
        }
        plotTop.setData([ ainData, gpioData ]);
        plotTop.draw();
    }

    function i2c(data) {
//        status_update("i2c: " + data);
        // Convert to F
        data = parseInt(data) / 16 / 16 * 9/5 +32;
//        status_update("i2c: " + data);
        i2cData[ii2c] = [ii2c, data];
        ii2c++;
        if(ii2c >= samples) {
            ii2c = 0;
            i2cData = [];
        }
        plotBot.setData([ i2cData ]);
        plotBot.draw();
    }

    function status_update(txt){
    //   document.getElementById('status').innerHTML = txt
    $('#status').html(txt);
    }

    function send(){
      socket.emit("ain", "Hello Server!");    
    }

//    connect();

$(function () {

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

    $("#i2cNum").val(i2cNum).change(function () {
        i2cNum = $(this).val();
    });

    $("#slider1").slider({min:0, max:100, slide: function(event, ui) {
	socket.emit("slider",  1, ui.value/100);
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
    plotBot = $.plot($("#plotBot"), 
        [ 
          { data:  initPlotData(),
            label: "i2c"}
        ],
            optionsBot);

    // Request data every updateInterval ms
    function updateTop() {
        socket.emit("ain",  ainNum[0]);
        socket.emit("gpio", gpioNum[0]);
        setTimeout(updateTop, updateTopInterval);
    }
    updateTop();

    function updateBot() {
        // socket.emit("i2c",  i2cNum);
        setTimeout(updateBot, updateBotInterval);
    }
    updateBot();
});
