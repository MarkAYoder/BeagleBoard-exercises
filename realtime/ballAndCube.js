// Extended example from https://github.com/mrdoob/three.js/
// http://www.aerotwist.com/tutorials/getting-started-with-three-js/
var socket,
    firstconnect = true,
    ainNum = ["P9_36", "P9_38"],       // Pot and ultrasound
    updateInterval = 50,   // In ms
    ainValue = [];
var camera, scene, renderer;
var geometry, material,
    ball, cube;

init();
animate();
connect();

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

        firstconnect = false;
      } else {
          }
        socket.emit("ain",  ainNum[0]);
        console.log("emitting: ain " + ainNum[0]);
        socket.emit("ain",  ainNum[1]);
      }

    function status_update(txt){
      document.getElementById('status').innerHTML = txt;
    }
    
    // When new data arrives, convert it and plot it.
    function ain(data) {
        var idx = ainNum.indexOf(data.pin); // Find position in ainNum array
        if(data.value !== "null") {
            ainValue[idx] = data.value;
        }
        status_update("\"" + data.value + "\"");
        console.log("data: " + data + " idx=" + idx);
        setTimeout(function(){socket.emit("ain", ainNum[idx]);}, updateInterval);
    }


function init() {
        // set the scene size
    var WIDTH = 800,
	    HEIGHT = 600;

	// set some camera attributes
	var VIEW_ANGLE = 10,
	    ASPECT = WIDTH / HEIGHT,
	    NEAR = 0.1,
	    FAR = 10000;

	// get the DOM element to attach to
	// - assume we've got jQuery to hand
	var $container = $('#container');

    scene = new THREE.Scene();

    geometry = new THREE.CubeGeometry(200, 100, 200);
    material = new THREE.MeshBasicMaterial({
        color: 0xff0000
//        wireframe: true
    });

    cube = new THREE.Mesh(geometry, material);
    scene.add(cube);
    console.log(cube);
    
    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    camera.position.z = 2000;
	scene.add(camera);
    
    geometry = new THREE.SphereGeometry(100, 32, 32);
    material = new THREE.MeshBasicMaterial({
        color: 0xff0000,
        wireframe: true
    });

    ball = new THREE.Mesh(geometry, material);
//    scene.add(ball);

    renderer = new THREE.CanvasRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);
//    renderer.setSize(WIDTH, HEIGHT);
    
    // attach the render-supplied DOM element
	$container.append(renderer.domElement);

//    document.body.appendChild(renderer.domElement);

}

function animate() {

    // note: three.js includes requestAnimationFrame shim
    requestAnimationFrame(animate);

    if(ainValue[1] > 0.05) {
        cube.position.y = 300*ainValue[1] - 50;
    }
    cube.rotation.y = 3*ainValue[0];
    cube.rotation.x = 3.14159/6;

/*
    if(ball.position.y > 100) {
        direction = -1;
    }
    if(ball.position.y < -100) {
        direction = 1;
    }
    ball.position.y += direction * 1;
*/

//    mesh2.position.x += 1;
    renderer.render(scene, camera);

}