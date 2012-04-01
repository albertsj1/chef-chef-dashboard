path = "/etc/chef/handlers/chef_dashboard_handler.rb" 

directory ::File.dirname(path) do
  owner "root"
  group "root"
  mode 00750
  action :create
end

template path do
  source 'chef_dashboard_handler.rb' 
end

chef_handler "Chef::DashboardHandler" do
  source path
  action :enable
end
