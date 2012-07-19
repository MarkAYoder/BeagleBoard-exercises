cd /home/root/exercises/node.js/GettingStarted
node ./realtimeDemo.js &
NODE_PID=$!
sleep 1

midori --app="localhost:8080/realtimeDemo.html"
kill -15 $NODE_PID

