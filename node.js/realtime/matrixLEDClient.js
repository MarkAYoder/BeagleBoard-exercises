    var socket;
    var firstconnect = true,
        fs = 8000,
        Ts = 1/fs*1000,
        samples = 100,
        plotTop,
        plotBot,
        ainData = [],  iain = 0, 
        gpioData = [], igpio = 0,
        i2cData = [],  ii2c = 0,
        gpioNum = 7,
        ainNum  = 6,
        i2cNum  = "0x70";
    ainData[samples] = 0;
    gpioData[samples] = 0;
    i2cData[samples] = 0;

// Create a matrix of LEDs
var matrix;
for(var j=0; j<8; j++) {
	matrix += '<tr>';
	for(var i=0; i<8; i++) {
	    matrix += '<td><div class="LED" id="id'+i+'_'+j+'" onclick="LEDclick('+i+','+j+')">'+i+','+j+'</div></td>';
	    }
	matrix += '</tr>';
}
$('#matrixLED').append(matrix);

function LEDclick(i, j) {
//	alert(i+","+j+" clicked");
	socket.emit('i2c', i2cNum);
	$('#id'+i+'_'+j).addClass('on');
}

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

        socket.on('i2c',  i2c);

        firstconnect = false;
      }
      else {
        socket.socket.reconnect();
      }
    socket.emit("i2c", i2cNum);
    }

    function disconnect() {
      socket.disconnect();
    }

    // When new data arrived, convert it and plot it.
    function i2c(data) {
	var i,j;
	var disp = [];
//        status_update("i2c: " + data);
	data = data.split(" ");
//        status_update("data: " + data);
	// Lower 8 bit are the Green color.  Ignore the red
	// Convert from hex
	for(i=0; i<data.length; i+=2) {
	    disp[i/2] = parseInt(data[i], 16);
	}
//        status_update("disp: " + disp);
	// i cycles through each column
	for(i=0; i<disp.length; i++) {
	    // j cycles through each bit
	    for(j=0; j<8; j++) {
		if(((disp[i]>>j)&0x1) === 1) {
		    $('#id'+i+'_'+j).addClass('on');
		} else {
		    $('#id'+i+'_'+j).removeClass('on');
		}
	    }
	}
    }

    function status_update(txt){
//        document.getElementById('status').innerHTML = txt;
	$('#status').html(txt);
    }

    function send(){
      socket.emit("ain", "Hello Server!");    
    };

connect();

$(function () {

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

    $("#slider1").slider().bind("slide", function(event, ui) {
	socket.emit("slider",  1, ui.value);
    });


    var updateInterval = 100;
    $("#updateInterval").val(updateInterval).change(function () {
        var v = $(this).val();
        if (v && !isNaN(+v)) {
            updateInterval = +v;
            if (updateInterval < 25)
                updateInterval = 25;
            if (updateInterval > 2000)
                updateInterval = 2000;
            $(this).val("" + updateInterval);
        }
    });

    // Request data every updateInterval ms

    function update() {
        socket.emit("i2c",  i2cNum);
	if(updateInterval !== 0) {
            setTimeout(updateBot, updateInterval);
	}
    }
    update();
});
