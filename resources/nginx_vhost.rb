def initialize(*args)
  super
  @action = :create
end

actions :create, :delete, :enable, :disable, :test

default_action :create

attribute :source, :kind_of =>  String
attribute :cookbook, :kind_of =>  String
attribute :load_order_position, :kind_of =>  [ String, Fixnum, Integer ], :default => "05"
attribute :is_default, :kind_of =>  [TrueClass, FalseClass], :default => false
attribute :deploy_to, :kind_of => String
attribute :port, :kind_of => [ String, Fixnum, Integer ], :default => "80"
attribute :namevirtualhost, :kind_of => String
attribute :servername, :kind_of => String
attribute :serveralias, :kind_of => Array
attribute :with_rewrite_log, :kind_of =>  [TrueClass, FalseClass], :default => false
attribute :directoryindex, :kind_of => String
attribute :doc_root, :kind_of => String
attribute :use_canonical_name, :kind_of => String
attribute :keepalive, :kind_of => String
attribute :maxkeepaliverequests, :kind_of => [ String, Fixnum, Integer ]
attribute :keepalivetimeout, :kind_of => [ String, Fixnum, Integer ]
attribute :default_type, :kind_of => String
attribute :enable_mmap, :kind_of => String
attribute :enable_sendfile, :kind_of => String
attribute :rewrite_log_level, :kind_of => String
attribute :log_level, :kind_of => String
attribute :log_type, :kind_of => String
attribute :with_includes_file, :kind_of =>  [TrueClass, FalseClass], :default => false
attribute :includes_file_cookbook, :kind_of =>  [TrueClass, FalseClass], :default => false
attribute :includes_file_names, :kind_of => Array
attribute :path, :kind_of => String
