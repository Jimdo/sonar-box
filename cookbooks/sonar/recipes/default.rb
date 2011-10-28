#Gem.clear_paths # needed for Chef to find the gem...
#require 'mysql' # requires the mysql gem
include_recipe "apt"
include_recipe "mysql::server"
package "wget"
package "unzip"

sonar = "sonar-#{node[:sonar][:version]}"

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
  command "wget http://dist.sonar.codehaus.org/#{sonar}.zip"
  creates "/home/sonar/#{sonar}"
  cwd "/home/sonar"
  user "sonar"
  not_if {File.exists?("/home/sonar/sonar-#{sonar}.zip")}
end

execute "Unzip sonar" do
  command "unzip #{sonar}.zip"
  creates "/home/sonar/#{sonar}"
  cwd "/home/sonar"
  user "sonar"
  not_if {File.exists?("/home/sonar/#{sonar}")}
end

execute "Install PHP Plugin" do
  command "wget http://repository.codehaus.org/org/codehaus/sonar-plugins/php/sonar-php-plugin/#{node[:sonar][:php_plugin_version]}/sonar-php-plugin-#{node[:sonar][:php_plugin_version]}.jar"
  creates "/home/sonar/#{sonar}/extensions/plugins/sonar-php-plugin-#{node[:sonar][:php_plugin_version]}.jar"
  cwd "/home/sonar/#{sonar}/extensions/plugins"
  user "sonar"
end

link "/usr/local/bin/sonar" do
  to "/home/sonar/#{sonar}/bin/linux-x86-32/sonar.sh"
end

cookbook_file "/etc/init.d/sonar" do
  source "sonar"
  mode 0755
  owner "root"
  group "root"
end

cookbook_file "/home/sonar/#{sonar}/conf/sonar.properties" do
  source "sonar.properties"
  mode 0755
  owner "sonar"
end

mysql_database "Create sonar database" do
  connection({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  database_name "sonar"
  action :create
end

service "sonar" do
  supports :status => true, :restart => true, :start => true, :stop => true
  status_command "/etc/init.d/sonar status | grep 'sonar is running'"
  action [:enable, :start]
end
