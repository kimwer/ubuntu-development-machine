echo "[INFO] Install Puppet"
sudo apt install puppet-common -y

if [ -f /home/vagrant/vagrant-ubuntu-oracle-xe/oracle-jdbc/ojdbc6.jar ]; then
    mkdir -p /etc/puppet/modules
    puppet module list | grep -q puppetlabs-java || puppet module install puppetlabs-java
    puppet module list | grep -q maestrodev-maven || puppet module install maestrodev-maven
  fi
  
  