echo '[INFO] Configure locale'
sudo locale-gen de_DE.UTF-8
sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'de'\"/g' /etc/default/keyboard
sudo localectl set-locale LANG=de_DE.UTF-8
sudo update-locale LC_ALL=de_DE.UTF-8