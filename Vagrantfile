Vagrant.configure("2") do |config|
  if Vagrant.has_plugin? "vagrant-vbguest"
    config.vbguest.no_install = true
    config.vbguest.auto_update = false
    config.vbguest.no_remote = true
  end

  config.vm.define :consul do |consul|
    consul.vm.box = "bento/ubuntu-22.04"
    consul.vm.network :private_network, ip: "192.168.100.15"
    consul.vm.hostname = "consul"
    consul.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "chef/cookbooks"
      chef.add_recipe "consul"
      chef.arguments = "--chef-license accept"
    end
  end

  config.vm.define :back1 do |back1|
    back1.vm.box = "bento/ubuntu-22.04"
    back1.vm.network :private_network, ip: "192.168.100.12"
    back1.vm.hostname = "back1"
    back1.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "chef/cookbooks"
      chef.add_recipe "backend"
      chef.json = { "ip_server" => "192.168.100.12" }
      chef.arguments = "--chef-license accept"
    end
  end

  config.vm.define :back2 do |back2|
    back2.vm.box = "bento/ubuntu-22.04"
    back2.vm.network :private_network, ip: "192.168.100.13"
    back2.vm.hostname = "back2"
    back2.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "chef/cookbooks"
      chef.add_recipe "backend"
      chef.json = { "ip_server" => "192.168.100.13" }
      chef.arguments = "--chef-license accept"
    end
  end

  config.vm.define :back3 do |back3|
    back3.vm.box = "bento/ubuntu-22.04"
    back3.vm.network :private_network, ip: "192.168.100.14"
    back3.vm.hostname = "back3"
    back3.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "chef/cookbooks"
      chef.add_recipe "backend"
      chef.json = { "ip_server" => "192.168.100.14" }
      chef.arguments = "--chef-license accept"
    end
  end

  config.vm.define :proxy do |proxy|
    proxy.vm.box = "bento/ubuntu-22.04"
    proxy.vm.network :private_network, ip: "192.168.100.16"
    proxy.vm.hostname = "proxy"
    proxy.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = "chef/cookbooks"
      chef.add_recipe "proxy"
      chef.arguments = "--chef-license accept"
    end
  end
end
