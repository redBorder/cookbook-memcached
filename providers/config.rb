action :add do
  begin
    memory = new_resource.memory
    logdir = new_resource.logdir
    user = new_resource.user
    group = new_resource.group
    port = new_resource.port
    maxconn = new_resource.maxconn
    cachesize = new_resource.cachesize
    options = new_resource.options

    # install package
    yum_package "memcached" do
      action :install
      flush_cache [ :before ]
    end

    user user do
      action :create
    end
  
    directory logdir do
      owner user
      group group
      mode 0770
      action :create
    end

    template "/etc/sysconfig/memcached" do
      source "memcached.erb"
      owner "root"
      group "root"
      mode 0644
      cookbook "memcached"
      variables ({
        :port => port,
        :user => user,
        :maxconn => maxconn,
        :cachesize => cachesize,
        :options => options
      })
      notifies :restart, "service[memcached]", :delayed 
    end  
 
    service "memcached" do
      service_name "memcached"
      supports :status => true, :reload => true, :restart => true, :start => true, :enable => true
      action [:enable,:start]
    end 

    Chef::Log.info("memcached has been configured correctly.")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :remove do
  begin

    logdir = new_resource.logdir
 
    service "memcached" do
      supports :stop => true
      action :stop
    end     

    # uninstall package
    yum_package "memcached" do
      action :purge
    end    

    directory logdir do
      action :delete
      recursive true   
    end

    file "/etc/sysconfig/memcached" do
      action :delete
    end

    Chef::Log.info("memcached has been deleted correctly.")
  rescue => e
    Chef::Log.error(e.message)
  end
end


