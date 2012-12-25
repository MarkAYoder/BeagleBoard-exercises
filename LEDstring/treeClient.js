    var socket;
    var firstconnect = true,
        samples = 100,
        plotTop,
        ainData = [],  iain = 0, 
        gpioData = [], igpio = 0,
        i2cData = [],  ii2c = 0,
        gpioNum = 7,
        ainNum  = 6,
        i2cNum  = "0x48";
    var LEDtest;
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
	socket.on('led', LEDdata);

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

    // When new data arrived, convert it and plot it.
    function ain(data) {
        data = atob(data)/4096 * 1.8;
        data = isNaN(data) ? 0 : data;
//        status_update("ain: " + data);
        ainData[iain] = [iain, data];
        iain++;
        if(iain >= samples) {
            iain = 0;
            ainData = [];
        }
        plotTop.setData([ ainData, gpioData ]);
        plotTop.draw();
    }

    function gpio(data) {
        data = atob(data);
//        status_update("gpio: " + data);
        gpioData[igpio] = [igpio, data];
        igpio++;
        if(igpio >= samples) {
            igpio = 0;
            gpioData = [];
        }
        plotTop.setData([ ainData, gpioData ]);
        plotTop.draw();
    }

    function LEDdata(data) {
//      data = atob(data);
      LEDtest = data;
      alert("LEDdata called: " + data);
      document.getElementById('program').innerHTML = "Test";
      document.getElementById('program').innerHTML = data;
    }

    function status_update(txt) {
      document.getElementById('status').innerHTML = txt;
    }

    function send() {
      var txt = document.getElementById('program').value.split("\n");
      status_update("Send: " + txt);
      socket.emit('rgb', txt[0]);
    };

    function getData() {
      socket.emit('getData', 160);
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

    $("#red").slider().bind("slide", function(event, ui) {
	socket.emit("slider",  0, ui.value);
    });

    $("#green").slider().bind("slide", function(event, ui) {
	socket.emit("slider",  1, ui.value);
    });

    $("#blue").slider().bind("slide", function(event, ui) {
	socket.emit("slider",  2, ui.value);
    });

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

    // setup plot
    var optionsTop = {
        series: { 
            shadowSize: 0, // drawing is faster without shadows
            points: { show: false},
            lines:  { show: true, lineWidth: 5},
        }, 
        yaxis:	{ min: 0, max: 2, 
                  zoomRange: [10, 256], panRange: [-128, 128] },
        xaxis:	{ show: true, 
                  zoomRange: [10, 100], panRange: [0, 100] },
        legend:	{ position: "sw" },
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

    // Request data every updateInterval ms
    function updateTop() {
        socket.emit("ain",  ainNum);
        socket.emit("gpio", gpioNum);
        setTimeout(updateTop, updateTopInterval);
    }
    updateTop();

});
