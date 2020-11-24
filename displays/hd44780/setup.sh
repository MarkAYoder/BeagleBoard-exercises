export LCD=/dev/lcd
sudo chown debian:debian /$LCD
sudo chmod 777 $LCD
ls -ls $LCD

echo "Hello\nWorld" > $LCD

echo "while [ 1 ]; do echo "hello, world!" > $LCD ; sleep 0.5; done"
