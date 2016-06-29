#
# Cookbook Name:: memcached
# Recipe:: default
#
# redborder 2016
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

iptables_config "config" do
  mystring "test"
  action :add
end
