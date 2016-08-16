# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # specify the official ubuntu desktop image by canonical
  config.vm.box = "ubuntu/xenial64"

  config.ssh.forward_agent = true
  config.vm.network "private_network", ip: "192.168.50.198"
  #config.vm.network "forwarded_port", guest: 80, host: 80
  #config.vm.network "forwarded_port", guest: 3000, host: 3000

  # Forward Oracle port
  config.vm.network :forwarded_port, guest: 1521, host: 1521
  # Specific configuration for virtual box so you can fine-tune various backing
  # providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4000"
    vb.customize ["modifyvm", :id, "--cpus", "2"]
    vb.gui = true
    vb.customize ["modifyvm", :id, "--monitorcount", "1"]
	# Enable DNS behind NAT
	vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    # fix the openGL bug in vb guest additions 5.20 causing chrome to be always on top
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
	# attribute name might be broken since 1604 has its hostname harcoded
	vb.customize ["modifyvm", :id, "--name", "oracle"]
  end
  # same as above, but with ugly old syntax. saved as comment as backup
  # config.vm.provider :virtualbox do |vb|
  # # Use VBoxManage to customize the VM
  # vb.customize ["modifyvm", :id,
  #               "--name", "oracle",
  #               # Oracle claims to need 512MB of memory available minimum
  #               "--memory", "512",
  #               # Enable DNS behind NAT
  #               "--natdnshostresolver1", "on"]
  # end
  # share this project under /home/vagrant/vagrant-ubuntu-oracle-xe
  config.vm.synced_folder ".", "/home/vagrant/vagrant-ubuntu-oracle-xe", :mount_options => ["dmode=777","fmode=666"]
  # and the git repository under /home/vagrant/git
  config.vm.synced_folder "c:/Diverses/Projekte/git/", "/home/vagrant/git", owner: "vagrant", group: "vagrant"
  # add the necessary configs for using git
  config.vm.provision "copy-ssh-keys", type: "file", source: "~/.ssh", destination: "."
  config.vm.provision "copy-gitconfig", type: "file", source: "~/.gitconfig", destination: ".gitconfig"  

  # Setting the timezone to Germany
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

  # Run the Maven goals for data-with-flyway | not yet... disabled until testdata on local DB is needed
  # config.vm.provision "shell", path: "flyway.sh"
end
