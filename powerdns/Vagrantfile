# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  public_key = IO.read(File.join(Dir.home, ".ssh", "id_rsa.pub"))

  config.vm.box = "centos/7"
  config.vm.provision "shell", inline: "iptables -F"
  config.ssh.forward_agent = true

  # Define the database node servers
  boxes = [
    { :name => "powerdns01", :ip => "192.168.0.10" }
  ]

  # Provision each of the VMs.
  boxes.each do |opts|
      config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name]
      config.vm.network :private_network, ip: opts[:ip]
      # PowerDNS nat
      config.vm.network "forwarded_port", guest: 53, host: 5300, protocol: "udp"
      config.vm.network "forwarded_port", guest: 80, host: 8080, protocol: "tcp"
      config.vm.network "forwarded_port", guest: 1951, host: 8081, protocol: "tcp"
      config.vm.provision "shell", inline: <<-SHELL
          set -e
          echo '#{public_key}' > /home/vagrant/.ssh/authorized_keys
          chmod 600 /home/vagrant/.ssh/authorized_keys
        SHELL
      config.vm.provision "shell", path: "scripts/install.sh"
    end
  end
end
