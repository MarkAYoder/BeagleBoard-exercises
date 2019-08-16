    var socket;
    var firstconnect = true,
        samples = 100,          // Number of values to plot
        gpioNum = [0, 1, 2, 3, 4],   // GPIO pins to plot
        plotTop, plotBot,
        topTimer, botTimer,     // The setInterval timers
        gpioData = [], igpio = [],  // The data to plot and the current index
        i;
        var updateBotInterval = 1000;    // Update interval in ms
        // var updateTopInterval = 100;

    // Initialize gpioData to be an array of arrays
    for (i = 0; i < gpioNum.length; i++) {
        gpioData[i] = [0];         // Put an array in
        gpioData[i][samples] = 0;  // Preallocate sample elements
        igpio[i] = 0;
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

        socket.on('temp', temp);

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

    function temp(data) {
	    var idx = data.zone;
        // var num = data[0];
        // data = atob(data[1]);
        // data = data[1];
        gpioData[idx][igpio[idx]] = [igpio[idx], data.value];
        igpio[idx]++;
        status_update("temp(" + idx + "): " + data.value + " igpio: " + igpio[idx]);
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

    function updateBot() {
        var i;
        // for (i = 0; i < gpioNum.length; i++) {
        //     socket.emit("gpio", gpioNum[i]);
        // }
        for (i = 0; i < gpioNum.length; i++) {
            socket.emit("temp", gpioNum[i]);
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
            if (updateBotInterval > 10000)
                updateBotInterval = 10000;
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
        yaxis:	{ min: 35, max: 60 },
        xaxis:	{ show: true },
        legend:	{ position: "ne" }
    };
    plotBot = $.plot($("#plotBot"), 
        [ 
          { data:  initPlotData(),
            label: "zone 0"},
          { data:  initPlotData(),
            label: "zone 1"},
          { data:  initPlotData(),
            label: "zone 2"},
          { data:  initPlotData(),
            label: "zone 3"},
          { data:  initPlotData(),
            label: "zone 4"}
        ],
            optionsBot);
});
