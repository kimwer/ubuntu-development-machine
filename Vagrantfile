# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # specify the official ubuntu desktop image by canonical
  config.vm.box = "boxcutter/ubuntu1604-desktop"
  config.vm.provision "overwrite-auto-update", type: "file", source: "./scripts/configuration/10periodic", destination: "/home/vagrant/10periodic"
  #unattended updates will cause this to fail at this certain point, since dpkg db could be locked
  config.vbguest.auto_update = false
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
	vb.customize ["modifyvm", :id, "--name", "vagrant"]
  end
  # share this project under /home/vagrant/vagrant-ubuntu-oracle-xe
  config.vm.synced_folder ".", "/home/vagrant/vagrant-ubuntu-oracle-xe", :mount_options => ["dmode=777","fmode=666"]
  # and the git repository under /home/vagrant/git
  config.vm.synced_folder "..", "/home/vagrant/git", owner: "vagrant", group: "vagrant"
  # add the necessary configs for using git
  config.vm.provision "copy-ssh-keys", type: "file", source: "~/.ssh", destination: "."
  config.vm.provision "copy-gitconfig", type: "file", source: "~/.gitconfig", destination: ".gitconfig"  

  # install all the dev stuff e.g. git, maven, puppet, chrome 
  
  $scripts = "scripts"
  $install = $scripts + "/install"
  $configuration = $scripts + "/configuration"
  # set the correct interface in grub
  config.vm.provision "configure-grub", type: "shell", path: $configuration + "/configure-grub.sh", privileged: true
  # wait for unattended-upgrades to complete, awkward to check for running processes but dpkg-db-lock wouldnt allow further installations
  config.vm.provision "waitloop-for-unattended-upgrades", type: "shell", path: $install + "/waitloop-for-unattended-upgrades.sh", privileged: true
  
  # Setting the timezone to Germany, dpkg-reconfigure should not be locked any more
  config.vm.provision :shell, :inline => "echo \"Europe/Berlin\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"
  
  config.vm.provision "install-git", type: "shell", path: $install + "/install-git.sh", privileged: true
  config.vm.provision "install-nodejs", type: "shell", path: $install + "/install-nodejs.sh", privileged: true
  config.vm.provision "install-xclip", type: "shell", path: $install + "/install-xclip.sh", privileged: true
  config.vm.provision "install-screen", type: "shell", path: $install + "/install-screen.sh", privileged: true
  config.vm.provision "install-tree", type: "shell", path: $install + "/install-tree.sh", privileged: true
  config.vm.provision "install-chrome", type: "shell", path: $install + "/install-chrome.sh", privileged: false
  
  config.vm.provision "uninstall-amazon", type: "shell", path: $install + "/uninstall-amazon.sh", privileged: false
  config.vm.provision "uninstall-office", type: "shell", path: $install + "/uninstall-office.sh", privileged: false
  
  config.vm.provision "install-puppet", type: "shell", path: $install + "/install-puppet.sh", privileged: true
  
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "base.pp"
    puppet.options = "--verbose --trace"
  end

  # Run the Maven goals for data-with-flyway | not yet... disabled until testdata on local DB is needed
  # config.vm.provision "shell", path: "flyway.sh"
end
