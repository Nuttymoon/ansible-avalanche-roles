# -*- mode: ruby -*-
# vi: set ft=ruby :

cluster = "avalanche"
machines = {
  validator01: { ip: "192.168.2.11", memory: 1024, cpus: 2 },
  validator02: { ip: "192.168.2.12", memory: 1024, cpus: 2 },
  validator03: { ip: "192.168.2.13", memory: 1024, cpus: 2 },
  validator04: { ip: "192.168.2.14", memory: 1024, cpus: 2 },
  validator05: { ip: "192.168.2.15", memory: 1024, cpus: 2 },
}

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  # Define VMs
  machines.each_with_index do |(name, props), i|
    config.vm.define "#{name}_#{cluster}".to_sym do |node|
      node.vm.network :private_network, ip: props[:ip]
      node.vm.hostname = "#{name}.#{cluster}.local" 
      node.vm.provider "virtualbox" do |n|
        n.name =  "#{name}.#{cluster}.local"
        n.memory = props[:memory]
        n.cpus = props[:cpus]
        n.customize ["modifyvm", :id, "--ioapic", "on"]
        n.gui = false
      end
    end
  end
end
