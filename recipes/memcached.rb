# Define Memcached Attributes
node.override['memcached']['memory'] = 64
node.override['memcached']['port'] = 11211
node.override['memcached']['user'] = "nobody"
node.override['memcached']['listen'] = "0.0.0.0"
node.override['memcached']['maxconn'] = 1024

# Install and Setup
include_recipe "memcached"

memcached_instance node['railsapp']['name']