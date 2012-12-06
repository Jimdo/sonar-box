Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"
  config.vm.forward_port 9000, 9000
  config.vm.forward_port 3306, 3306
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe("apt")
    chef.add_recipe("openssl")
    chef.add_recipe("build-essential")
    chef.add_recipe("mysql::server")
    chef.add_recipe("java")
    chef.add_recipe("vagrant_main")
    chef.json = { :mysql => { :server_root_password => "root", :bind_address => "0.0.0.0" } }
  end
end
