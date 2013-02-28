#
# Cookbook Name:: railsapp
# Recipe:: default
#

# So we can rewind rsources where we don't like what they do
chef_gem "chef-rewind"
require 'chef/rewind'

# TODO move to ssh cookbook
template "/etc/ssh/ssh_config"
  source "ssh_config.erb"
end

include_recipe "resolver"
if Chef::Config[:solo]
  Chef::Log.warn("This recipe etcautohosts uses search. Chef Solo does not support search.")
else
  if node['railsapp']['with_auto_hosts'] == true
    include_recipe "autoetchosts"
  end
end
include_recipe "apt"
include_recipe "build-essential"
include_recipe "xml"
include_recipe "xslt"
include_recipe "imagemagick::devel"
include_recipe "logrotate"
include_recipe "railsapp::env"
include_recipe "railsapp::user"
include_recipe "railsapp::ruby"
include_recipe "railsapp::dependencies"
include_recipe "railsapp::config"
include_recipe "railsapp::monit"
include_recipe "railsapp::nginx_passenger"
if node['railsapp']['app_type'] == "sinatra"
  include_recipe "railsapp::sinatra"
end
if node['railsapp']['app_type'] == "rails"
  include_recipe "railsapp::rails"
end
if node['railsapp']['with_memcached'] == true
  include_recipe "railsapp::memcached"
end
# include_recipe "railsapp::admin"
include_recipe "railsapp::rewind"
#include_recipe "railsapp::finalize"

