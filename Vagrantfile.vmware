default_box = "generic/opensuse15"
default_timeout = 3600
max_node_port = 30010
master_ip_address = "192.168.0.200"

Vagrant.configure("2") do |config|
  config.vm.boot_timeout = default_timeout

  config.vm.define "master" do |master|
    master.vm.box = default_box
    master.vm.hostname = "master"

    # VMware Provider VM Settings
    master.vm.provider "vmware_desktop" do |v, override|
      v.gui = false
      v.vmx["memsize"] = "4096"
      v.vmx["numvcpus"] = "2"
      v.vmx["cpuid.coresPerSocket"] = "2"
      override.vm.network 'private_network', ip: master_ip_address

      # NodePort Port Forwardings for VMware
      # Limited to 10 for the project as this seems to be the most I could generate.
      # expose NodePort IP's
      for p in 30000..max_node_port
        override.vm.network "forwarded_port", guest: p, host: p, protocol: "tcp"
      end
    end

    # Virtualbox Provider VM Settings
    master.vm.provider "virtualbox" do |vb, override|
      vb.memory = "3072"
      vb.name = "master"
      override.vm.network 'private_network', ip: master_ip_address,  virtualbox__intnet: true

      # NodePort Port Forwardings from Vagrantfile.orig for Virtualbox
      # expose NodePort IP's
      for p in 30000..30100
        override.vm.network "forwarded_port", guest: p, host: p, protocol: "tcp"
      end
    end

    # Ip interfaces and basic portforwarding for admin
    master.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
    master.vm.network "forwarded_port", guest: 22, host: 2000 # Master Node SSH
    master.vm.network "forwarded_port", guest: 6443, host: 6443 # API Access

    # Install k3s requirements
    master.vm.provision "shell", inline: <<-SHELL
      sudo zypper refresh
      sudo zypper --non-interactive install bzip2
      sudo zypper --non-interactive install etcd
      sudo zypper --non-interactive install apparmor-parser
      curl -sfL https://get.k3s.io | sh -
    SHELL
  end 

end
