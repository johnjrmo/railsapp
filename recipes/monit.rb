if node["platform"] == "centos"
  include_recipe "yum::epel"
end

node.set['monit']['address'] = ''
node.set['monit']['allow'] = %w{0.0.0.0/0}

include_recipe "monit::service"
include_recipe "monit::ssh"
include_recipe "monit::nginx"

# Since we're using monit set it as the service command initiator
service "nginx" do
  supports :status => true, :restart => true, :reload => true
  start_command "monit start nginx"
  stop_command "monit stop nginx"
	restart_command "monit restart nginx"
  action :nothing
end
