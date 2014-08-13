# This finds your location based on your ip address
# From http://learn.linksprite.com/pcduino/linux-applications/how-to-look-up-the-geographic-location-of-an-ip-address-from-the-command-line/
# This lets you run the database in the cloud
apt-get install geoip-bin
geoiplookup 137.112.4.196

# This installed the database locally
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
wget http://download.maxmind.com/download/geoip/database/asnum/GeoIPASNum.dat.gz
gunzip GeoIP.dat.gz
gunzip GeoIPASNum.dat.gz
gunzip GeoLiteCity.dat.gz
mv GeoIP.dat GeoIPASNum.dat GeoLiteCity.dat /usr/share/GeoIP

geoiplookup 173.194.46.100
geoiplookup -f /usr/share/GeoIP/GeoLiteCity.dat 72.21.215.232

# Here's another online way
curl ipinfo.io/23.66.166.151

# Or a fancier way
curl ipinfo.io/`host www.rose-hulman.edu | awk '{print $NF}'`
