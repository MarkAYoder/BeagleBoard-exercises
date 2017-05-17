# Goes to rcn-ee to list current images
SITE=https://rcn-ee.com/rootfs/bb.org/testing/ 
curl $SITE | sed -n '/^$/!{s/<[^>]*>//g;p;}' 
echo $SITE
