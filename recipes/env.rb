%w(MERB_ENV RACK_ENV RAILS_ENV).each do |variable|
  ruby_block variable do
    var_line = %{#{variable}="#{node['railsapp']['rails_env']}"}

    block do
      file = Chef::Util::FileEdit.new("/etc/environment")
      file.search_file_replace_line(variable, var_line)
      file.insert_line_if_no_match(variable, var_line)
      file.write_file
    end

    not_if "grep '#{var_line}' /etc/environment"
  end
end
