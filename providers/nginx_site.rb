
action :create do
  unless exists?
    Chef::Log.info("Creating #{@new_resource} at #{vhost_conf_path}")

    template vhost_conf_path do
      cookbook source_cookbook
      source source_template
      action :create
      owner "root"
      group nginx_group
      mode 0644
      variables(
        :port => port,
        :namevirtualhost => namevirtualhost_id,
        :servername => servername,
        :serveralias => serveralias,
        :with_rewrite_log => with_rewrite_log,
        :directoryindex => directoryindex,
        :doc_root => doc_root,
        :deploy_root => current_resource.deploy_to,
        :use_canonical_name => use_canonical_name,
        :keepalive => keepalive,
        :maxkeepaliverequests => maxkeepaliverequests,
        :keepalivetimeout => keepalivetimeout,
        :default_type => default_type,
        :enable_mmap => enable_mmap,
        :enable_sendfile => enable_sendfile,
        :with_includes_file => with_includes_file,
        :includes_file_cookbook => includes_file_cookbook,
        :includes_file_names => includes_file_names,
        :log_level => log_level,
        :log_type => log_type,
        :rewrite_log_level => rewrite_log_level
      )
      notifies :restart, "service[nginx]", :delayed
      # notifies :reload, "service[nginx]", :delayed
      # notify_nginx_restart?
    end

    new_resource.updated_by_last_action(true)
  else
    Chef::Log.info("#{@new_resource} at #{vhost_conf_path} already exists")
    new_resource.updated_by_last_action(false)
  end

end

action :delete do
  if exists?
    if ::File.writable?(vhost_conf_path)
      Chef::Log.info("Deleting #{@new_resource} at #{vhost_conf_path}")
      Chef::Log.info("Deleting #{@new_resource} at #{vhost_conf_d_dir}")
      ::File.delete(vhost_conf_path)
      ::FileUtils.rm_rf(vhost_conf_d_dir)
      new_resource.updated_by_last_action(true)
    else
      raise "Cannot delete #{@new_resource} at #{vhost_conf_path}!"
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::nginxVhost.new(new_resource.name)
  @current_resource.path(vhost_conf_path)
  @current_resource.deploy_to(vhost_deploy_to)
  @current_resource
  log_lwrp_init(@current_resource)
  Chef::Log.info("current_resource.name value is:".upcase + " #{current_resource.name}")
  Chef::Log.info("vhost_deploy_to value is:".upcase + " #{vhost_deploy_to}")
  Chef::Log.info("doc_root value is:".upcase + " #{doc_root}")
  Chef::Log.info("servername value is:".upcase + " #{servername}")
  Chef::Log.info("serveralias value is:".upcase + " #{serveralias}")
  Chef::Log.info(("current_resource.path value is:".upcase + " #{current_resource.path}"))
  Chef::Log.info(("vhost_conf_path value is:".upcase + " #{vhost_conf_path}"))
  Chef::Log.info(("vhost_conf_d_dir value is:".upcase + " #{vhost_conf_d_dir}"))
  Chef::Log.info("source_template value is:".upcase + " #{source_template}")
  Chef::Log.info("source_cookbook value is:".upcase + " #{source_cookbook}")
  Chef::Log.info("port value is:".upcase + " #{port}")
  Chef::Log.info("log_level value is:".upcase + " #{log_level}")
  Chef::Log.info("log_type value is:".upcase + " #{log_type}")
end

def source_cookbook
  @new_resource.cookbook || "nginx"
end

def source_template
  @new_resource.source || "vhost.conf.erb"
end

def vhost_deploy_to
  @current_resource.deploy_to || node['railsapp']['deploy_to']
end

def vhost_conf_path
  ::File.join(nginx_dir, "/vhosts.d/#{vhost_file_name}.conf")
end

def vhost_conf_d_dir
  ::File.join(::File.dirname(vhost_conf_path), "#{@current_resource.name}.d")
end

def doc_root
  ::File.join(vhost_deploy_to, "current/public")
end

def nginx_dir
  node[:nginx][:dir] || "/etc/nginx"
end

def nginx_group
  node[:nginx][:base][:root_group]
end

def port
  @new_resource.port
end

def vhost_load_order
  @new_resource.load_order_position || nil
end

def vhost_name
  @new_resource.servername || @current_resource.name
end

def vhost_file_name
  if @new_resource.is_default == true
    "0000_default_#{vhost_name}"
  else
    unless vhost_load_order.nil?
      "#{vhost_load_order}_#{vhost_name}"
    else
      vhost_name
    end
  end
end

def namevirtualhost_id
  @new_resource.namevirtualhost || "*"
end

def namevirtualhost
  @new_resource.namevirtualhost
end

def servername
  # @new_resource.servername ||
  @current_resource.name
end

def serveralias
  @new_resource.serveralias
end

def with_includes_file
  @new_resource.with_includes_file || false
end

def includes_file_cookbook
  @new_resource.includes_file_cookbook
end

def includes_file_names
  @new_resource.includes_file_names
end

def log_type
  @new_resource.log_type || "combined"
end

def log_level
  @new_resource.log_level || "info"
end

private

def exists?
  ::File.exist?(@current_resource.deploy_to)
end

def enabled?
  ::File.exist?(@current_resource.path)
end
