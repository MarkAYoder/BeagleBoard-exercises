# Launch 5 sledders
for i in {1..5}
do
  ./tree 3 60000 20000 &
  sleep 1.25
done
