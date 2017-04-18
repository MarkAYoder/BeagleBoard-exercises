# This is to switch cloud 9 to user debian
# Edit /lib/systemd/system/cloud9.service and add
User=debian
# Edit /etc/default/cloud9 and change HOME to
HOME=/home/debian
# Then run
sudo systemctl restart cloud9

# Here's what Robert says to do:
sudo apt update ; sudo apt upgrade
cd /opt/scripts/
git pull
sudo reboot

# This is old stuff
# Then run
sudo chown -R :cloud9ide /var/lib/cloud9/ || true 
sudo chmod -R g+w /var/lib/cloud9/ || true 
sudo chown -R :cloud9ide /opt/cloud9/.c9/ || true 
sudo chmod -R g+w /opt/cloud9/.c9/ || true

# Now fix the gpio permissions
sudo chown -R root:gpio /sys/class/gpio 
sudo chmod -R ug+rw /sys/class/gpio

# See: https://github.com/rcn-ee/repos/blob/master/bb-customizations/suite/jessie/debian/80-gpio-noroot.rules
