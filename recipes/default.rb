require 'etc'

include_recipe "nginx"
include_recipe "unicorn2"

package "libsqlite3-dev"

node["dashboard"]["install_path"].split('/').inject("/") do |x,y|
  dir = ::File.join(x, y)
  directory dir do
    owner "root"
    group "root"
    mode 00755
    action :create
  end
  dir
end

user "rails" do
  gid "rails"
  home node["dashboard"]["install_path"]
  supports(:manage_home => true)
  action [:create, :manage]
end

group "rails" do
  members %w[rails]
  append true
  action :manage
end

directory node["dashboard"]["install_path"] do
  owner "rails"
  group "rails"
  mode 00755
end

gem_package "bundler" do
  version '~> 1.1.0'
end

bash "bundle #{node["dashboard"]["install_path"]}" do
  code <<-EOF
    set -e
    cd '#{node["dashboard"]["install_path"]}'
    '#{File.dirname(Gem.ruby)}/bundle' --deployment --without 'development test'
  EOF

  user "rails"
  group "rails"

  action :nothing
end

bash "create database for chef-dashboard" do
  code <<-EOF
    set -e
    cd '#{node["dashboard"]["install_path"]}'
    echo n | '#{Gem.ruby}' 'bin/create_database'
  EOF

  user "rails"
  group "rails"

  action :nothing
  not_if "test -f #{node["dashboard"]["install_path"]}/dashboard.db"
end

# FIXME the unicorn2 recipe should handle this better.
bash "restart unicorn_rack for chef-dashboard" do
  code <<-EOF
    '#{Gem.ruby}' /etc/init.d/unicorn_rack restart '#{node["dashboard"]["install_path"]}'
  EOF

  action :nothing
end

git node["dashboard"]["install_path"] do
  repository node["dashboard"]["repository"]
  revision node["dashboard"]["revision"]
  user "rails"
  group "rails"
  action :sync

  notifies :run, "bash[bundle #{node["dashboard"]["install_path"]}]", :immediately
  notifies :run, "bash[create database for chef-dashboard]", :immediately
  notifies :run, "bash[restart unicorn_rack for chef-dashboard]"
end

template "/etc/nginx/sites-available/default" do
  source "nginx.conf.erb"
  action :create
end

link "/etc/nginx/sites-enabled/default" do
  to "/etc/nginx/sites-available/default"
  action :create
  notifies :stop, "service[nginx]"
  notifies :start, "service[nginx]"
end

include_recipe "chef-dashboard::dashboard_hook"
