// Extended example from https://github.com/mrdoob/three.js/
// http://www.aerotwist.com/tutorials/getting-started-with-three-js/
var socket,
    firstconnect = true,
    ainNum = ["P9_36", "P9_38"],       // Pot and ultrasound
    updateInterval = 50,   // In ms
    ainValue = [];
var camera, scene, renderer;
var geometry, material,
    ball, cube, torus;

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
//        console.log("emitting: ain " + ainNum[0]);
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
//        console.log("data: " + data + " idx=" + idx);
        setTimeout(function(){socket.emit("ain", ainNum[idx]);}, updateInterval);
    }


function init() {
        // set the scene size
    var WIDTH = 800,
	    HEIGHT = 600;

	// set some camera attributes
	var VIEW_ANGLE = 15,
	    ASPECT = WIDTH / HEIGHT,
	    NEAR = 0.1,
	    FAR = 10000;

    scene = new THREE.Scene();
    
    var faceColors = [0x7f0000, 0x00ff00, 0x0000ff, 0xff0000, 0x007f00, 0x7f0000];
    
    geometry = new THREE.CubeGeometry(200, 100, 200);
    for ( var i = 0; i < geometry.faces.length; i += 2 ) {
/*
        var hex = Math.random() * 0xffffff;
    	geometry.faces[ i ].color.setHex( hex );
    	geometry.faces[ i + 1 ].color.setHex( hex );
//        console.log("i=" + i);
*/
        geometry.faces[ i ].color.setHex(faceColors[i/2]);
        geometry.faces[ i + 1 ].color.setHex(faceColors[i/2]);
    }
//    console.log(geometry);
    material = new THREE.MeshBasicMaterial({
//        color: 0xff0000,
//        wireframeLinewidth: 10,
        vertexColors: THREE.FaceColors, overdraw: true
//        wireframe: true
    });

    cube = new THREE.Mesh(geometry, material);

    scene.add(cube);
    // console.log(cube);
/*
	var loader = new THREE.TextureLoader();
	loader.load( 'beagle-hd-logo.gif', function ( texture ) {

		var geometry = new THREE.SphereGeometry( 100, 200, 100 );

		var material = new THREE.MeshBasicMaterial( { map: texture, overdraw: true } );
		var boris = new THREE.Mesh( geometry, material );
        boris.position.x = -200;
        boris.rotation.y = Math.PI/3;
		scene.add( boris );
        console.log( boris );
	} );
*/                
    geometry = new THREE.SphereGeometry(100, 32, 32);
    material = new THREE.MeshBasicMaterial({
        color: 0x0000ff,
        wireframe: true
    });

    ball = new THREE.Mesh(geometry, material);
    ball.position.x = -200;
//    scene.add(ball);

    geometry = new THREE.TorusGeometry(100, 40, 32, 16);
    material = new THREE.MeshBasicMaterial({
        color: 0x00ff00,
        wireframe: false
    });

    torus = new THREE.Mesh(geometry, material);
    torus.position.x = 200;
//    scene.add(torus);

    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    camera.position.z = 2000;
    scene.add(camera);
    
    renderer = new THREE.CanvasRenderer();
    // renderer = new THREE.WebGLRenderer();
    renderer.setSize(window.innerWidth, window.innerHeight);
//    renderer.setSize(WIDTH, HEIGHT);
    
    // get the DOM element to attach to
	// - assume we've got jQuery to hand
	var $container = $('#container');
    // attach the render-supplied DOM element
	$container.append(renderer.domElement);

//    document.body.appendChild(renderer.domElement);

}

function animate() {

    // note: three.js includes requestAnimationFrame shim
    requestAnimationFrame(animate);

    // if(ainValue[1] > 0.05) {
    //     cube.position.y = 300*ainValue[1] - 50;
    // }
    cube.rotation.y = 6*ainValue[0];
    cube.rotation.x = 6*ainValue[1];
    // cube.rotation.x = 3.14159/6;

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