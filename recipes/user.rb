# Create user and group
#
group node['railsapp'][:user] do
  action :create
end

user node['railsapp'][:user] do
  comment  "Application User"
  gid      node['railsapp'][:user]
  shell    "/bin/bash"
  action   :create
end

group node['railsapp'][:user] do
  members [ node['railsapp'][:user] ]
  action :create
end
