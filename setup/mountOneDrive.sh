# Here's how to mount OneDrive files using rclone (https://rclone.org/)
# Install (https://rclone.org/downloads/).  This gets the most current version
# sudo apt update
# sudo apt install curl
# curl https://rclone.org/install.sh | sudo bash

# Configure using instructions here: https://elinux.org/EBC_Exercise_04_Mounting_OneDrive
# mkdir onedrive
rclone mount onedrive: onedrive --daemon

# When done
# sudo umount onedrive
