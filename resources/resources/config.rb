# Cookbook:: memcached
# Resource:: config

actions :add, :remove, :register, :deregister
default_action :add

attribute :memory, kind_of: Integer, default: 524288
attribute :user, kind_of: String, default: 'memcached'
attribute :group, kind_of: String, default: 'memcached'
attribute :port, kind_of: Integer, default: 11211
attribute :maxconn, kind_of: Integer, default: 1024
attribute :cachesize, kind_of: Integer, default: 512
attribute :options, kind_of: String, default: '-I 10m -v'
attribute :ipaddress, kind_of: String, default: '127.0.0.1'
