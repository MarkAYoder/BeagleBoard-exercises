cd /home/root/exercises/node.js/realtime
node ./boneServer.js &
NODE_PID=$!
sleep 1

midori --app="localhost:8080/audio.html"
kill -15 $NODE_PID
