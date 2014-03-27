# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "hashicorp/precise32"

  # port forwarding
  config.vm.network :forwarded_port, host: 8081, guest: 80 #apache
  config.vm.network :forwarded_port, host: 3307, guest: 3306 #mysql

  # private network
  config.vm.network "private_network", ip: "192.168.33.10"

  # provisioning
  # config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.options = ['--verbose']
  end
end
