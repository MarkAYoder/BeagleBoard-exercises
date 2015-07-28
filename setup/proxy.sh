# Set proxy for IIT Mandi
# Install with apt-get install dconf-tools
for proxy in ftp http https socks 
do
    echo $proxy 
    dconf write /system/proxy/$proxy/host "'10.8.0.1'"
    dconf write /system/proxy/$proxy/port "'8080'"
done

# I don't know if this is needed on the Bone, but it's needed on the host to reach the Bone
dconf write /system/proxy/ignore-hosts "['localhost', '127.0.0.0/8', '192.168.7.0/8']"
dconf dump /system/proxy/  

# git config --global http.proxy http://10.8.0.1:8080
# git config --global https.proxy https://10.8.0.1:8080
