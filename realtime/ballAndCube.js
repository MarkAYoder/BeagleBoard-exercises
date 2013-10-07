// Extended example from https://github.com/mrdoob/three.js/
// http://www.aerotwist.com/tutorials/getting-started-with-three-js/
var socket,
    firstconnect = true;
var camera, scene, renderer;
var geometry, material, mesh, mesh2;
var direction = 1;

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
      }

    function status_update(txt){
      document.getElementById('status').innerHTML = txt;
    }

function init() {
        // set the scene size
    var WIDTH = 400,
	    HEIGHT = 300;

	// set some camera attributes
	var VIEW_ANGLE = 75,
	    ASPECT = WIDTH / HEIGHT,
	    NEAR = 0.1,
	    FAR = 10000;

	// get the DOM element to attach to
	// - assume we've got jQuery to hand
	var $container = $('#container');

    scene = new THREE.Scene();

    geometry = new THREE.CubeGeometry(200, 200, 200);
    material = new THREE.MeshBasicMaterial({
        color: 0xff00cc,
        wireframe: true
    });

    mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);
    console.log(mesh);
    
    camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
    camera.position.z = 300;
	scene.add(camera)
    
    geometry = new THREE.SphereGeometry(100, 16, 16);
    material = new THREE.MeshBasicMaterial({
        color: 0xff0000,
//        wireframe: true
    });

    mesh2 = new THREE.Mesh(geometry, material);
    scene.add(mesh2);

    renderer = new THREE.CanvasRenderer();
//    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setSize(WIDTH, HEIGHT);
    
    // attach the render-supplied DOM element
	$container.append(renderer.domElement);

//    document.body.appendChild(renderer.domElement);

}

function animate() {

    // note: three.js includes requestAnimationFrame shim
    requestAnimationFrame(animate);

    mesh.rotation.x += 0.01;
    mesh.rotation.y += 0.02;

    if(mesh2.position.y > 100) {
        direction = -1;
    }
    if(mesh2.position.y < -100) {
        direction = 1;
    }
    mesh2.position.y += direction * 1;

//    mesh2.position.x += 1;
    renderer.render(scene, camera);

}