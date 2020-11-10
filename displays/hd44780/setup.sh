export LCD=/dev/lcd
sudo chown debian:debian /$LCD
sudo chmod g+rw $LCD
ls -ls $LCD

echo "Hello\nWorld" > $LCD

# while [ 1 ]; do echo "hello, world!" > $LCD ; sleep 0.5; done
