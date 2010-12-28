Gem.clear_paths # needed for Chef to find the gem...
require 'mysql' # requires the mysql gem
include_recipe "apt"
include_recipe "mysql::server"
package "wget"

user "sonar" do
  home "/home/sonar"
  shell "/bin/bash"
end

directory "/home/sonar" do
  recursive true
  owner "sonar"
  mode 0700
end

execute "Download sonar" do
  command "wget http://dist.sonar.codehaus.org/#{node[:sonar][:version]}.zip"
  creates "/home/sonar/#{node[:sonar][:version]}.zip"
  cwd "/home/sonar"
  user "sonar"
end

execute "Unzip sonar" do
  command "unzip #{node[:sonar][:version]}.zip"
  creates "/home/sonar/#{node[:sonar][:version]}"
  cwd "/home/sonar"
  user "sonar"
end

execute "Install PHP Plugin" do
  command "wget http://repository.codehaus.org/org/codehaus/sonar-plugins/sonar-php-plugin/0.3/sonar-php-plugin-0.3.jar"
  creates "/home/sonar/#{node[:sonar][:version]}/extensions/plugins/sonar-php-plugin-0.3.jar"
  cwd "/home/sonar/#{node[:sonar][:version]}/extensions/plugins"
  user "sonar"
end

link "/usr/local/bin/sonar" do
  to "/home/sonar/#{node[:sonar][:version]}/bin/linux-x86-32/sonar.sh"
end

cookbook_file "/etc/init.d/sonar" do
  source "sonar"
  mode 0755
  owner "root"
  group "root"
end

cookbook_file "/home/sonar/#{node[:sonar][:version]}/conf/sonar.properties" do
  source "sonar.properties"
  mode 0755
  owner "sonar"
end

mysql_database "Create sonar database" do
  host "localhost"
  username "root"
  password node[:mysql][:server_root_password]
  database "sonar"
  action :create_db
end



service "sonar" do
  supports :status => true, :restart => true, :start => true, :stop => true
  status_command "/etc/init.d/sonar status | grep 'sonar is running'"
  action [:enable, :start]
end
