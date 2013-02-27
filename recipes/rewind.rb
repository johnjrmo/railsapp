


# From nginx::passenger recipe
rewind :template => "#{node["nginx"]["dir"]}/conf.d/passenger.conf" do
  source "module.passenger.conf.erb"
  cookbook "railsapp"
  owner "root"
  group "root"
  mode 00644
  variables(
    :passenger_root => node["nginx"]["passenger"]["root"],
    :passenger_ruby => node["nginx"]["passenger"]["ruby"],
    :passenger_max_pool_size => node["nginx"]["passenger"]["max_pool_size"],
    :passenger_spawn_method => node["nginx"]["passenger"]["spawn_method"],
    :passenger_use_global_queue => node["nginx"]["passenger"]["use_global_queue"],
    :passenger_buffer_response => node["nginx"]["passenger"]["buffer_response"],
    :passenger_max_pool_size => node["nginx"]["passenger"]["max_pool_size"],
    :passenger_min_instances => node["nginx"]["passenger"]["min_instances"],
    :passenger_max_instances_per_app => node["nginx"]["passenger"]["max_instances_per_app"],
    :passenger_pool_idle_time => node["nginx"]["passenger"]["pool_idle_time"],
    :passenger_max_requests => node["nginx"]["passenger"]["max_requests"],
    :passenger_user => node['railsapp']['user'] ? node['railsapp']['user'] : node['nginx']['user'],
    :rails_env => node['railsapp']['rails_env'] ? node['railsapp']['rails_env'] : "development"
  )
  notifies :reload, "service[nginx]"
end

# From nginx::source
rewind :template => "#{node["nginx"]["dir"]}/sites-available/default" do
  action :nothing
end
