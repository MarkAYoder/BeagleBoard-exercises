# Run demos for New York World Maker Faire 2017
./sequence.py &
./i2cmatrix.py &

cd ../ili9341
./on.sh
sudo fbi -noverbose -T 1 -a tux.png
cd ../demo
