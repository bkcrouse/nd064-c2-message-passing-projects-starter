default_box = "generic/opensuse15"
Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.box = default_box
    master.vm.hostname = "master"

    # VMware VM Settings
    master.vm.provider "vmware_desktop" do |v|
      v.gui = false
      v.vmx["memsize"] = "4096"
      v.vmx["numvcpus"] = "2"
      v.vmx["cpuid.coresPerSocket"] = "2"
    end

    # Ip interfaces and basic portforwarding for admin
    master.vm.network 'private_network', ip: "192.168.0.200"
    master.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: true
    master.vm.network "forwarded_port", guest: 22, host: 2000 # Master Node SSH
    master.vm.network "forwarded_port", guest: 6443, host: 6443 # API Access

    # NodePort Port Forwardings - vmware seems to have timeout issue with configuring 100 of these, or it's timing out
    # reduced to 10 for the project.
    # expose NodePort IP's
    #
    for p in 30000..30010 
       master.vm.network "forwarded_port", guest: p, host: p, protocol: "tcp"
    end

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
