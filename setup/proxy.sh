# Set proxy for IIT Mandi
# Install with apt-get install dconf-tools
for proxy in ftp http https socks 
do
    echo $proxy 
    dconf write /system/proxy/$proxy/host "'10.8.0.1'"
    dconf write /system/proxy/$proxy/port "'8080'"
done

# I don't know if this is needed on the Bone, but it's needed on the host to reach the Bone
dconf write /system/proxy/ignore-hosts "['localhost', '127.0.0.0/8', '192.168.7.0/8', '::1']"
dconf write /system/proxy/mode  "'manual'"
dconf write /system/proxy/use-same-proxy  "false"
dconf dump /system/proxy/  

export http_proxy=http://10.8.0.1:8080/
export https_proxy=https://10.8.0.1:8080/

# From http://jjasonclark.com/how-to-setup-node-behind-web-proxy/
npm config set proxy http://10.8.0.1:8080
npm config set https-proxy http://10.8.0.1:8080

git config --global http.proxy http://10.8.0.1:8080
git config --global https.proxy https://10.8.0.1:8080
