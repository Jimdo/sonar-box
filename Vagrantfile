Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.forward_port "sonar", 9000, 9000
  config.vm.provisioner = :chef_solo
  config.chef.cookbooks_path = ["cookbooks", "../opscode-cookbooks"]
  config.chef.add_recipe("vagrant_main")
end
