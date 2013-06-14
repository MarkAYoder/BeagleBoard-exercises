var socket;
var firstconnect = true;

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
    socket.on('updatePage', function()
        { document.location.reload(true); });

    firstconnect = false;
  }
  else {
    socket.socket.reconnect();
  }
}

function disconnect() {
  socket.disconnect();
}

function status_update(txt){
  document.getElementById('status').innerHTML = txt;
}

