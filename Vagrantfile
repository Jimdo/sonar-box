Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.forward_port "sonar", 9000, 9000
  config.vm.forward_port "mysql", 3306, 3306
  config.vm.provisioner = :chef_solo
  config.chef.cookbooks_path = ["cookbooks"]
  config.chef.add_recipe("apt")
  config.chef.add_recipe("openssl")
  config.chef.add_recipe("build-essential")
  config.chef.add_recipe("mysql::server")
  config.chef.add_recipe("vagrant_main")
  config.chef.json.merge!({ :mysql => { :server_root_password => "root" } })
end
