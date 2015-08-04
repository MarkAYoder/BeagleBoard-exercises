# From: http://phant.io/beaglebone/install/2014/07/03/beaglebone-black-install/

npm install -g phant
phant &
# Browse to http://14.139.34.32:8080/ and click "Create" and fill in the fields
# Record the public/private/delete keys
export phant_PUBLIC=8BqVYqVlerhpE2m1zBaXh0L8Nvz
export phant_PRIVATE=ylDNWDNO7yFGDwORErVjCN84lmz
export phant_DELETE=apqOGqOoB7sYRNPypWz3hRLYzAP

# Log some data
wget http://14.139.34.32:8080/input/$phant_PUBLIC?private_key=$ylDNWDNO7yFGDwORErVjCN84lmz\&amplitude=23.29\&timestamp=25.94