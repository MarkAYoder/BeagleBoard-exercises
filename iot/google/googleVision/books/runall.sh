# This takes images of book covers and resizes then, then
# Send them to Google Vision to see what text is on the cover

# Resize all the images and put in resize/
for file in SAM_42*
do
    echo $file
    convert $file -resize 180x320 ../resize/$file
done

# run the script to send to Google
for file in resize/*;
do 
    echo $file;
    ./pic.sh $file
done
