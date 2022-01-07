action :add do
  begin
    memory = new_resource.memory
    logdir = new_resource.logdir
    user = new_resource.user
    group = new_resource.group
    port = new_resource.port
    maxconn = new_resource.maxconn
    cachesize = new_resource.cachesize
    maxitemsize = new_resource.maxitemsize
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
        :maxitemsize => maxitemsize,
        :logdir => logdir,
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
    #yum_package "memcached" do
    #  action :purge
    #end    

    #directory logdir do
    #  action :delete
    #  recursive true   
    #end

    #file "/etc/sysconfig/memcached" do
    #  action :delete
    #end

    Chef::Log.info("memcached has been deleted correctly.")
  rescue => e
    Chef::Log.error(e.message)
  end
end


action :register do #Usually used to register in consul
  begin
    if !node["memcached"]["registered"]
      query = {}
      query["ID"] = "memcached-#{node["hostname"]}"
      query["Name"] = "memcached"
      query["Address"] = "#{node["ipaddress"]}"
      query["Port"] = 11211
      json_query = Chef::JSONCompat.to_json(query)

      execute 'Register service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/register -d '#{json_query}' &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.set["memcached"]["registered"] = true
    end
    Chef::Log.info("memcached service has been registered in consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end

action :deregister do #Usually used to deregister from consul
  begin
    if node["memcached"]["registered"]
      execute 'Deregister service in consul' do
        command "curl -X PUT http://localhost:8500/v1/agent/service/deregister/memcached-#{node["hostname"]} &>/dev/null"
        action :nothing
      end.run_action(:run)

      node.set["memcached"]["registered"] = false
    end
    Chef::Log.info("memcached service has been deregistered from consul")
  rescue => e
    Chef::Log.error(e.message)
  end
end
