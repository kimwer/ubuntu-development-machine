echo "[INFO] Install Puppet"
sudo apt install puppet-common -y

if [ !-f /home/vagrant/vagrant-ubuntu-oracle-xe/oracle-jdbc/ojdbc6.jar ]; then
    echo "[ERROR] Fatal error: ojdbc has not been found"
fi
  
mkdir -p /etc/puppet/modules
puppet module list | grep -q puppetlabs-java || puppet module install puppetlabs-java
puppet module list | grep -q maestrodev-maven || puppet module install maestrodev-maven
echo "[INFO] Finished installing Puppet"