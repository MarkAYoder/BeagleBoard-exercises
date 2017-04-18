# This is to switch cloud 9 to user debian
# Edit /lib/systemd/system/cloud9.service and add
User=debian
# Edit /etc/default/cloud9 and change HOME to
/etc/default/cloud9
# Then run
sudo systemctl restart cloud9

# Then run
sudo chown -R :cloud9ide /var/lib/cloud9/ || true 
sudo chmod -R g+w /var/lib/cloud9/ || true 
sudo chown -R :cloud9ide /opt/cloud9/.c9/ || true 
sudo chmod -R g+w /opt/cloud9/.c9/ || true


