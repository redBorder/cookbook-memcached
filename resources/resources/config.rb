# Cookbook Name:: memcached
#
# Resource:: config
#

actions :add, :remove
default_action :add

attribute :memory, :kind_of => Fixnum, :default => 524288
attribute :logdir, :kind_of => String, :default => "/var/log/memcached"
attribute :user, :kind_of => String, :default => "memcached"
attribute :group, :kind_of => String, :default => "memcached"
attribute :port, :kind_of => Fixnum, :default => 11211
attribute :maxconn, :kind_of => Fixnum, :default => 1024
attribute :cachesize, :kind_of => Fixnum, :default => 128
attribute :options, :kind_of => String, :default => ""

