directory "/home/#{node['railsapp']['user']}/.ssh" do
  owner node['railsapp']['user']
  group node['railsapp']['user']
  recursive true
end

cookbook_file "/home/#{node['railsapp']['user']}/.ssh/id_rsa" do
  source "git_deploy_key"
  cookbook node['railsapp']['cookbook']
  owner node['railsapp']['user']
  group node['railsapp']['user']
  mode 00600
end

cookbook_file "/home/#{node['railsapp']['user']}/.ssh/known_hosts" do
  source "known_hosts"
  cookbook node['railsapp']['cookbook']
  owner node['railsapp']['user']
  group node['railsapp']['user']
  mode 00644
end
