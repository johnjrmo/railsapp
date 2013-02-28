
if(node.run_state[:seen_recipes].has_key?("ruby_build"))
	unless(node.run_state[:seen_recipes].has_key?("rbenv"))
		ruby_prefix = node['ruby_build']['default_ruby_base_path']
	else
		ruby_prefix = node['rbenv']['root_path']
	end
	node.override["railsapp"]["bundler"]["gem_binary"] = "#{ruby_prefix}/bin/gem"
else
	node.override["railsapp"]["bundler"]["gem_binary"] = node['languages']['ruby']['gem_bin']
end


if node['railsapp']['use_deploy_key']
  include_recipe "railsapp::deploy_key"
end

gem_package "bundler" do
  action :install
  version node["railsapp"]["bundler"]["version"] if node["railsapp"]["bundler"]["version"]
  gem_binary node["railsapp"]["bundler"]["gem_binary"] if node["railsapp"]["bundler"]["gem_binary"]
end

directory "#{node['railsapp']['deploy_to']}" do
  owner node['railsapp']['user']
  group node['railsapp']['user']
  recursive true
end

%w( shared/
    shared/config
    shared/pids
    shared/system
    shared/log ).each do |d|
  directory "#{node['railsapp']['deploy_to']}/#{d}" do
    owner node['railsapp']['user']
    group node['railsapp']['user']
    recursive true
  end
end

if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
  node.override['railsapp']['hosts'] = {
    "auth_basic" => {
      "fqdn" => "mongo1"
    },
    "auth_digest" => {
      "fqdn" => "mongo1"
    }
  }
  db_host = node['railsapp']['hosts']
else
  db_host = search(:node, "role:#{node['railsapp']['db_host_role']}") 
end

db_host.each do |d|
  puts d['fqdn']
end

puts "#{node['railsapp']['deploy_to']}/shared/config/mongodb.yml"
 
template "#{node['railsapp']['deploy_to']}/shared/config/mongodb.yml" do
   source "mongo.yml.erb"
   owner node['railsapp']['user']
   group node['railsapp']['user']
   mode 00744
   variables({
       :app_name => node['railsapp']['app_name'],
       :db_pass => node['railsapp']['db_pass'],
       :db_host => db_host,
       :db_type => node['railsapp']['db_adapter']
   })
end

deploy_revision node['railsapp']['deploy_to'] do
  repository node['railsapp']['repository']
  revision node['railsapp']['revision']
  user node['railsapp']['user']
  migrate node['railsapp']['migrate'] if node['railsapp']['migrate']
  migration_command node['railsapp']['migration_command'] if node['railsapp']['migration_command']
  environment "RAILS_ENV" => node['railsapp']['rails_env']
  shallow_clone true

  # before_migrate do
  #   execute "bundle gems" do
  #     command "bundle install " +
  #       # "--deployment --without development test " +
  #       node['railsapp']['deployment_command'] +
  #       "--path #{node['railsapp']['deploy_to']}/shared/bundle " +
  #       "--binstubs #{node['railsapp']['deploy_to']}/shared/bundle/bin"
  #     user node['nginx']['user']
  #     group node['nginx']['user']
  #     cwd release_path
  #   end
  # end

 restart do
   execute "restart app" do
     command "touch #{node['railsapp']['deploy_to']}/current/tmp/restart.txt"
     user node['railsapp']['user']
   end
 end


  action node['railsapp']['deploy_action']
end

# link "#{node['railsapp']['deploy_to']}/current/config/mongodb.yml" do
#   to "#{node['railsapp']['deploy_to']}/shared/config/mongodb.yml"
# end