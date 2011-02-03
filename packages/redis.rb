package :redis do 
  requires :build_essentials
  source "http://redis.googlecode.com/files/redis-2.2.0-rc2.tar.gz" do
    pre :install, "killall -9 redis-server || true"
    custom_install 'make install'
  end
  verify do
    has_executable 'redis-server'
    has_executable_with_version('redis-server', '2.1.10', '--version')
  end  
end

package :redis_service do 
  requires :redis
  transfer "#{File.dirname(__FILE__)}/../config/redis.conf", 'redis.conf', :sudo => true do
    pre :install, "rm -f /etc/redis.conf"
    pre :install, "sudo adduser redis --system --no-create-home --disabled-password --disabled-login --group"
    post :install, "sudo mkdir -p /etc/redis"
    post :install, "sudo mkdir -p /var/db/redis"
    post :install, "sudo mv redis.conf /etc/redis/6379.conf"
  end
  transfer "#{File.dirname(__FILE__)}/../config/redis", 'redis', :sudo => true do
    post :install, "cp redis /etc/init.d/redis"
    post :install, "sudo chmod +x /etc/init.d/redis"
    post :install, "sudo update-rc.d redis defaults"
    # need a sleep here so the shell can actually fork before we terminate the session
    post :install, "sudo /etc/init.d/redis start && sleep 1"
  end

  verify do
    has_file '/etc/init.d/redis'
    has_process 'redis'
  end
end