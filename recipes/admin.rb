  directory "/var/www/admin" do
    owner node['nginx']['user']
    group node['nginx']['user']
    recursive true
  end

template "#{node["nginx"]["dir"]}/sites-available/admin" do
  source "nginx.admin.conf.erb"
  owner "root"
  group "root"
  mode 00644
#  variables(
#    :deploy_to => node['railsapp']['deploy_to'],
#    :rails_env => node['railsapp']['rails_env']
#  )
#  notifies :restart, "service[nginx]", :delayed
end


ruby_block "store node data locally" do
  block do
    state = File.open("/var/www/admin/index.html", "w")

    node.run_state[:seen_recipes].keys.each do |recipe|
        state.puts("recipe.#{recipe}")
    end

    node.run_state[:seen_attributes].keys.each do |attribute|
        state.puts("attribute.#{attribute}")
    end

    node.run_list.roles.each do |role|
        state.puts("role.#{role}")
    end

    state.close
  end
end

ruby_block "store node data locally" do
  block do
		require 'yaml'
		data = node
		File.open("/var/www/admin/index.yml", "w") {|f| f.write(data.to_yaml) }
  end
end

%w{ html yml }.each do |ext|
	file "/var/www/admin/index.#{ext}" do
		mode 00644
	end
end

nginx_site "admin"


##
# Accompanying Library
##

#search :apps do |app|
#  if (app['server_roles'] & node.run_list.roles).any?
#    if app.fetch("ingredients", {}).any? { |role, ingredients| node.run_list.roles.include?(role) && ingredients.include?("newrelic.yml") }
#      newrelic_config = app.fetch("newrelic", {})
#      default_config = newrelic_config.fetch("_default", {})
#      chef_environment_config = newrelic_config.fetch(node.chef_environment, {})

#      framework_environment_config = Chef::Mixin::DeepMerge.merge(default_config, chef_environment_config)
#      framework_environment_config['license_key'] ||= node['newrelic']['license_key']
#      config = Apps::DeepToHash.to_hash(node['framework_environment'] => framework_environment_config)

#      file "#{app['deploy_to']}/shared/config/newrelic.yml" do
#        owner app['owner']
#        group app['group']
#        mode "660"
#        content config.to_yaml
#      end
#    end
#  end
#end
