    var socket;
    var firstconnect = true,
        fs = 8000,
        Ts = 1/fs*1000,
        samples = 800,
        plotTop, plotBot,
        globalDataL = [],
        globalDataR = [];
    globalDataL[samples] = 0;
    globalDataR[samples] = 0;

    function connect() {
      if(firstconnect) {
        socket = io.connect(null);

        socket.on('audio', function(data){ audio(data); });
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

        firstconnect = false;
      }
      else {
        socket.socket.reconnect();
      }
    }

    function disconnect() {
      socket.disconnect();
    }

    // When new data has arrived, convert it and plot it.
    function audio(data) {
        var myData = window.atob(data);
        var fftSize = 512;
        var fftOutL, fftOutR;
        // Pull out left and right channels
        for(var i=0; i<samples; i++) {
            globalDataL[i] = [i*Ts, myData.charCodeAt(2*i  )-128];
            globalDataR[i] = [i*Ts, myData.charCodeAt(2*i+1)-128];
        }
        plotTop.setData([ globalDataL, globalDataR ]);
        
        fftOutL = fft(globalDataL, fftSize);
        fftOutR = fft(globalDataR, fftSize);
        plotBot.setData([ fftOutL, fftOutR ]);
        // since the axes don't change, we don't need to call plot.setupGrid()
        plotTop.draw();
        plotBot.draw();

      document.getElementById('message').innerHTML = "Server says: " +
          globalDataL.length + " points: ";
    }
    
    function fft(data, size) {
        // Take the fft
        var fftData = new Float32Array(size);
        var fft = new FFT(size, fs);
        var fftOut = new Array(size);
        var i;
        for (i = 0; i < size; i++) {
            fftData[i] = data[i][1]; // Pull the y-values out
        }
        fft.forward(fftData);
        for (i = 0; i < size; i++) {
            fftOut[i] = [i*fs/size, 10*Math.log(fft.spectrum[i])/Math.LN10];
        }
        return fftOut;
    }

    function status_update(txt){
      document.getElementById('status').innerHTML = txt;
    }

    function send(){
      socket.send("Hello Server!");    
    }

// jQuery
$(function () {

    function initPlotData() {
        // zip the generated y values with the x values
        var result = [];
        for (var i = 0; i <= samples; i++)
            result[i] = [i*Ts, 0];
        return result;
    }

    // setup control widget
    var updateInterval = 100;
    $("#updateInterval").val(updateInterval).change(function () {
        var v = $(this).val();
        if (v && !isNaN(+v)) {
            updateInterval = +v;
            if (updateInterval < 1)
                updateInterval = 1;
            if (updateInterval > 2000)
                updateInterval = 2000;
            $(this).val("" + updateInterval);
        }
    });

    // setup plot
    var optionsTop = {
        series: { 
            shadowSize: 0, // drawing is faster without shadows
            points: { show: false},
            lines:  { show: true, lineWidth: 3}
        }, 
        yaxis:  { min: -50, max: 50 },
        xaxis:	{ show: true },
        legend:	{ position: "ne" }
    };
    plotTop = $.plot($("#plotTop"), 
        [ 
          { data:  initPlotData(), 
            label: "Left Channel" },
          { data:  initPlotData(),
            label: "Right Channel" }
        ],
            optionsTop );

    var optionsBot = {
        series: { 
            shadowSize: 0, // drawing is faster without shadows
            points: { show: false},
            lines:  { show: true, lineWidth: 3}
        }, 
        yaxis:    { min: -25, max: 25}, 
        xaxis:    { min: 0, max: 2000, show: true}, 
        legend:	{ position: "ne" }
    };
    plotBot = $.plot($("#plotBot"), 
        [ 
          { data:  initPlotData(), 
            label: "Left Channel" },
          { data:  initPlotData(),
            label: "Right Channel" }
        ],
            optionsBot);

    // Request data every updateInterval ms
    function update() {
        socket.emit('audio', "Send more data");
        setTimeout(update, updateInterval);
    }
    update();
});

