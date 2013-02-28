##
# Nginx Settings
##

node.override['nginx']['user']                  = 'nginx'
node.override["nginx"]["passenger"]["version"]  = "3.0.19"
node.override['nginx']['init_style']            = "runit"
node.override['nginx']['version']               = "1.2.6"
node.override['nginx']['install_method']        = 'source'
node.override['nginx']['default_site_enabled']  = false
node.set['nginx']['source']['prefix']           = "/usr/local"
node.set['nginx']['client_max_body_size']       = "100m"

# Paths
if(node.run_state[:seen_recipes].has_key?("ruby_build"))
	unless(node.run_state[:seen_recipes].has_key?("rbenv"))
		ruby_prefix = node['ruby_build']['default_ruby_base_path']
	else
		ruby_prefix = node['rbenv']['root_path']
	end
	node.override["nginx"]["passenger"]["root"]       = "#{ruby_prefix}/lib/ruby/gems/1.9.1/gems/passenger-#{node['nginx']['passenger']['version']}"
	node.override["nginx"]["passenger"]["ruby"]       = "#{ruby_prefix}/bin/ruby"
	node.override["nginx"]["passenger"]["gem_binary"] = "#{ruby_prefix}/bin/gem"

else
	node.override["nginx"]["passenger"]["root"]       = "#{node['languages']['ruby']['gems_dir']}/lib/ruby/gems/1.9.1/gems/passenger-#{node['nginx']['passenger']['version']}"
	node.override["nginx"]["passenger"]["ruby"]       = node['languages']['ruby']['ruby_bin']
	node.override["nginx"]["passenger"]["gem_binary"] = node['languages']['ruby']['gem_bin']
end

##
# Compile Runtime Options
##

# Configure Flags. Make Sure Any Modules Included As Recipes Match i.e not opposite and stepping on
#node.override['nginx']['configure_flags'] = [
node.override['nginx']['source']['default_configure_flags'] = [
  "--prefix=#{node['nginx']['source']['prefix']}",
  "--conf-path=#{node['nginx']['dir']}/nginx.conf",
	"--pid-path=#{node['nginx']['pid']}",
	"--error-log-path=#{node['nginx']['log_dir']}",
	"--http-log-path=#{node['nginx']['log_dir']}",
	"--user=#{node['nginx']['user']}",
	"--group=#{node['nginx']['user']}",
	"--without-http_proxy_module",
	"--without-http_scgi_module",
	"--without-http_fastcgi_module",
	"--without-http_memcached_module",
	"--without-http_ssi_module",
	"--without-http_upstream_ip_hash_module",
	"--without-mail_pop3_module",
	"--without-mail_imap_module",
	"--without-mail_smtp_module",
	"--without-http_autoindex_module",
	"--without-http_empty_gif_module"
]

# Include Modules Via Recipe, Make Sure Config Flags Above Match
node.override['nginx']['source']['modules'] = [
  "passenger",
  "headers_more_module",
  "http_stub_status_module",
	"http_realip_module"
]

##
# Build 
##

include_recipe "nginx"
