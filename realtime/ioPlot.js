    var socket;
    var firstconnect = true,
        samples = 100,          // Number of values to plot
        gpioNum = ["P9_42", "P9_41"],   // GPIO pins to plot
        ainNum  = ["P9_37", "P9_35"],   // Analog ins to plot
        plotTop, plotBot,
        topTimer, botTimer,     // The setInterval timers
        gpioData = [], igpio = [],  // The data to plot and the current index
        ainData  = [], iain  = [],
        i;
        var updateBotInterval = 100;    // Update interval in ms
        var updateTopInterval = 100;

    // Initialize gpioData and ainData to be an array of arrays
    for (i = 0; i < gpioNum.length; i++) {
        gpioData[i] = [0];         // Put an array in
        gpioData[i][samples] = 0;  // Preallocate sample elements
        igpio[i] = 0;
    }
    for(i=0; i<ainNum.length; i++) {
        ainData[i] = [0];
        ainData[i][samples] = 0;
        iain[i] = 0;
    }
    
    function connect() {
      if(firstconnect) {
        socket = io.connect(null);

        socket.on('message', function(data)
            { status_update("Received: message " + data);});
        socket.on('connect', function()
            { status_update("Connected to Server"); });
        socket.on('disconnect', function()
            { status_update("Disconnected from Server"); });
        socket.on('reconnect', function()
            { status_update("Reconnected to Server"); });
        socket.on('reconnecting', function( nextRetry )
            { status_update("Reconnecting in " + nextRetry/1000 + " s"); });
        socket.on('reconnect_failed', function()
            { status_update("Reconnect Failed"); });

        socket.on('ain',  ain);
        socket.on('gpio', gpio);

        firstconnect = false;
        updateTop();
      }
      else {
        socket.socket.reconnect();
        botTimer = setInterval(updateBot, updateBotInterval);
        //topTimer = setInterval(updateTop, updateTopInterval);
        updateTop();
        }
    }

    function disconnect() {
      clearInterval(botTimer);
      //clearInterval(topTimer);
      socket.disconnect();
    }

    function led(ledNum) {
        socket.emit('led', ledNum);
    }

    function trigger(trig) {
        socket.emit('trigger', trig);
    }

    // When new data arrives, convert it and plot it.
    function ain(data) {
        var idx = ainNum.indexOf(data.pin); // Find position in ainNum array
//        var num = data[0];
//        data = data.value;
//        status_update("ain" + num + "(" + idx + "): " + data + ", iain: " + iain[idx]);
        ainData[idx][iain[idx]] = [iain[idx], data.value];
        iain[idx]++;
        if(iain[idx] >= samples) {
            iain[idx] = 0;
            ainData[idx] = [];
        }
        plotTop.setData(ainData);
        plotTop.draw();
        setTimeout(function(){socket.emit("ain", data.pin);}, updateTopInterval);
    }

    function gpio(data) {
	    var idx = gpioNum.indexOf(data.pin);
//        var num = data[0];
//        data = atob(data[1]);
//        data = data[1];
        gpioData[idx][igpio[idx]] = [igpio[idx], data.value];
        igpio[idx]++;
//        status_update("gpio" + num + "(" + idx + "): " + data + " igpio: " + igpio[idx]);
        if(igpio[idx] >= samples) {
            igpio[idx] = 0;
            gpioData[idx] = [];
        }
        plotBot.setData(gpioData);
        plotBot.draw();
    }

    function status_update(txt){
      document.getElementById('status').innerHTML = txt;
    }

    // Request data every updateInterval ms
    function updateTop() {
        var i;
        for(i=0; i<ainNum.length; i++) {
            socket.emit("ain", ainNum[i]);
        }
    }
    //topTimer = setInterval(updateTop, updateTopInterval);

    function updateBot() {
        var i;
        for (i = 0; i < gpioNum.length; i++) {
            socket.emit("gpio", gpioNum[i]);
        }
    }
    botTimer = setInterval(updateBot, updateBotInterval);

// Here's the jQuery
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
        ainNum = $(this).val().split(",");
        updateTop();
    });

    $("#gpioNum").val(gpioNum).change(function () {
        gpioNum = $(this).val().split(",");
    });

    $("#updateTopInterval").val(updateTopInterval).change(function () {
        var v = $(this).val();
        if (v && !isNaN(+v)) {
            updateTopInterval = +v;
            if (updateTopInterval < 10)
                updateTopInterval = 10;
            if (updateTopInterval > 2000)
                updateTopInterval = 2000;
            $(this).val("" + updateTopInterval);
        }
        // Reset the timer
        //clearInterval(topTimer);
        //topTimer = setInterval(updateTop, updateTopInterval);
    });

    $("#updateBotInterval").val(updateBotInterval).change(function () {
        var v = $(this).val();
        if (v && !isNaN(+v)) {
            updateBotInterval = +v;
            if (updateBotInterval < 10)
                updateBotInterval = 10;
            if (updateBotInterval > 2000)
                updateBotInterval = 2000;
            $(this).val("" + updateBotInterval);
        }
        // Reset timer
        clearInterval(botTimer);
        botTimer = setInterval(updateBot, updateBotInterval);
    });

    // setup plot
    var optionsTop = {
        series: { 
            shadowSize: 0, // drawing is faster without shadows
            points: { show: false},
            lines:  { show: true, lineWidth: 5}
        }, 
        yaxis:	{ min: 0, max: 2 },
        xaxis:	{ show: true },
        legend:	{ position: "ne" }
    };
    plotTop = $.plot($("#plotTop"), 
        [ 
          { data:  initPlotData(), 
            label: "Bird Sonar"},
          { data:  initPlotData(),
            label: "Scanner Sonar"}
        ],
            optionsTop);

    var optionsBot = {
        series: { 
            shadowSize: 0, // drawing is faster without shadows
            points: { show: false},
            lines:  { show: true, lineWidth: 5}
        }, 
        yaxis:	{ min: 0, max: 2 },
        xaxis:	{ show: true },
        legend:	{ position: "ne" }
    };
    plotBot = $.plot($("#plotBot"), 
        [ 
          { data:  initPlotData(),
            label: "gpio7"},
          { data:  initPlotData(),
            label: "gpio20"}
        ],
            optionsBot);
});
