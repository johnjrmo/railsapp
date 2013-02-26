# Install any application package dependencies
if node['railsapp']['packages']
  node['railsapp']['packages'].each do |pkg,ver|
    package pkg do
      action :install
      version ver if ver && ver.length > 0
    end
  end
end

# Install any application gem dependencies
if node['railsapp']['gems']
  node['railsapp']['gems'].each do |gem,ver|
    gem_package gem do
      action :install
      version ver if ver && ver.length > 0
    end
  end
end

