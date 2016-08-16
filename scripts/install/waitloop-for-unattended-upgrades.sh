#!/bin/bash
sleep 30
isRunning=$(pgrep -cf "apt-get|dpkg")
echo "$isRunning"
echo '[INFO] Checking for unattended upgrades to complete'
while [ "$isRunning" -gt 0 ] 
do
echo "E: dpkg or apt-get are still running."
sleep 0.5
done
sudo /bin/cp -f /home/vagrant/10periodic /etc/apt/apt.conf.d/10periodic
echo '[INFO] Check completed'
