# This is for mounting windows files using Vbox
# Go to Devices/Shared Folder and share "Documents"
mount-/media/windows
mkdir -p $mount
sudo mount -t vboxsf Documents $mount
