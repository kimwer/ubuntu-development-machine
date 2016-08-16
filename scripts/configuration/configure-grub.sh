echo '[INFO] Configure grub'
sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 net.ifnames=0 biosdevname=0\"/" /etc/default/grub
sudo sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 net.ifnames=0 biosdevname=0\"/" /etc/default/grub
sudo update-grub