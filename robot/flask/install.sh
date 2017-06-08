# From https://blog.miguelgrinberg.com/post/easy-websockets-with-flask-and-gevent
git clone https://github.com/miguelgrinberg/Flask-SocketIO
cd Flask-SocketIO/example
sudo apt update
sudo apt install python3-pip
pip3 install -r requirements.txt
# Edit app.py to include: socketio.run(app, host='0.0.0.0')

cd templates
wget https://code.jquery.com/jquery-3.2.1.min.js
wget https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.0.2/socket.io.slim.js

cd ..
python3 robot.py

