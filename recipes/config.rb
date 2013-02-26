# Create the deploy_to directory.
directory node['railsapp']['deploy_to'] do
  owner node['railsapp']['owner']
  group node['railsapp']['group']
  mode '0755'
  recursive true
end

# Create the shared directory.
directory "#{node['railsapp']['deploy_to']}/shared" do
  owner node['railsapp']['owner']
  group node['railsapp']['group']
  mode '0755'
  recursive true
end

# Create the shared directory sub-directories.
%w{ log pids system config vendor_bundle }.each do |dir|

  directory "#{node['railsapp']['deploy_to']}/shared/#{dir}" do
    owner node['railsapp']['owner']
    group node['railsapp']['group']
    mode '0755'
    recursive true
  end

end

template "#{node['railsapp']['deploy_to']}/shared/config/database.yml" do
  owner node['railsapp']['owner']
  group node['railsapp']['group']
  mode '0755'
  recursive true
end

template "#{node['railsapp']['deploy_to']}/shared/#{dir}" do
  owner node['railsapp']['owner']
  group node['railsapp']['group']
  mode '0755'
  recursive true
end

