# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # specify the official ubuntu desktop image by canonical
  config.vm.box = "ubuntu/xenial64"

  config.ssh.forward_agent = true
  config.vm.network "private_network", ip: "192.168.50.198"
  #config.vm.network "forwarded_port", guest: 80, host: 80
  #config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8000"
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.gui = true
    vb.customize ["modifyvm", :id, "--monitorcount", "1"]
    # fix the openGL bug in vb guest additions 5.20 causing chrome to be always on top
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
  end
    
  # share this project under /home/vagrant/vagrant-ubuntu-oracle-xe
  config.vm.synced_folder ".", "/home/vagrant/vagrant-ubuntu-oracle-xe", :mount_options => ["dmode=777","fmode=666"]

  # Forward Oracle port
  config.vm.network :forwarded_port, guest: 1521, host: 1521

  # Provider-specific configuration so you can fine-tune various backing
  # providers for Vagrant. These expose provider-specific options.
  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM
    vb.customize ["modifyvm", :id,
                  "--name", "oracle",
                  # Oracle claims to need 512MB of memory available minimum
                  "--memory", "512",
                  # Enable DNS behind NAT
                  "--natdnshostresolver1", "on"]
  end

  # This is just an example, adjust as needed
  config.vm.provision :shell, :inline => "echo \"Europe/Berlin\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"

  config.vbguest.auto_update = true

  $install_puppet_modules = <<SCRIPT
  if [ -f /home/vagrant/vagrant-ubuntu-oracle-xe/oracle-jdbc/ojdbc6.jar ]; then
    mkdir -p /etc/puppet/modules
    puppet module list | grep -q puppetlabs-java || puppet module install puppetlabs-java
    puppet module list | grep -q maestrodev-maven || puppet module install maestrodev-maven
  fi
SCRIPT

  config.vm.provision "shell", inline: $install_puppet_modules

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "base.pp"
    puppet.options = "--verbose --trace"
  end

  # Run the Maven goals for data-with-flyway
  config.vm.provision "shell", path: "flyway.sh"
end
