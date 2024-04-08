# Cookbook Name:: memcached
#
# Resource:: config
#

actions :add, :remove, :register, :deregister
default_action :add

attribute :memory, :kind_of => Fixnum, :default => 524288
attribute :user, :kind_of => String, :default => "memcached"
attribute :group, :kind_of => String, :default => "memcached"
attribute :port, :kind_of => Fixnum, :default => 11211
attribute :maxconn, :kind_of => Fixnum, :default => 1024
attribute :cachesize, :kind_of => Fixnum, :default => 512
attribute :maxitemsize, :kind_of => String, :default => "10m"
attribute :options, :kind_of => String, :default => " -v"
attribute :ipaddress, :kind_of => String, :default => "127.0.0.1"
