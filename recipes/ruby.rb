# list of additional rubies that will be installed
#node.override['rbenv']['rubies']      = [ "1.9.3-p327" ]

#node.override['rbenv']['gems'] = {
#  '1.9.3-p327' => [
#    { 'name'    => 'vagrant' },
#    { 'name'    => 'bundler' }
#  ],
#  '1.8.7-p352' => [
#    { 'name'    => 'nokogiri' }
#  ]
#}
#include_recipe "ruby"

#node.default['ruby_build']['ruby_system_version'] = "1.9.3-p328"

ruby_prefix = node.set['ruby_build']['default_ruby_base_path'] = "/usr/local"
ruby_system_version = node.set['ruby_build']['ruby_system_version'] = "1.9.3-p327"


file "/etc/gemrc" do
  content 'gem: --no-ri --no-rdoc'
  mode 00644
  action :nothing
end.run_action(:create) 

include_recipe "ruby_build"

#node.set['ruby_build']['ruby_system_version'] = "1.9.3"

ruby_build_ruby ruby_system_version do
  prefix_path ruby_prefix
  action      :install
end

#node.set['languages']['ruby']['bin_dir'] = "#{ruby_prefix}/bin"
#node.set['languages']['ruby']['ruby_bin'] = "#{ruby_prefix}/bin/ruby"
#node.set['languages']['ruby']['gem_bin'] = "#{ruby_prefix}/bin/gem"
#node.set['languages']['ruby']['gem_dir'] = "#{ruby_prefix}/lib/ruby/gems/1.9.1"

#node.set['ruby_build']['ruby_system_version'] = "1.9.3"
#node.set['languages']['ruby']['bin_dir'] = "#{ruby_prefix}/bin"
#node.set['languages']['ruby']['ruby_bin'] = "#{ruby_prefix}/bin/ruby"
#node.set['languages']['ruby']['gem_bin'] = "#{ruby_prefix}/bin/gem"
#node.set['languages']['ruby']['gem_dir'] = "#{ruby_prefix}/lib/ruby/gems/1.9.1"
#node.override["nginx"]["passenger"]["root"] = "/usr/local/lib/ruby/gems/1.9.1/gems/passenger-3.0.19"
#node.override["nginx"]["passenger"]["ruby"] = "/usr/local/bin/ruby"
