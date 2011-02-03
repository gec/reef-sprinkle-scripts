package :qpidd_deps do
  apt %w(build-essential ruby uuid-dev libtool swig libsasl2-dev sasl2-bin)
end

package :qpidd do
  requires :qpidd_deps, :boost_1_45
  transfer "#{File.dirname(__FILE__)}/../installer_scripts/install-qpid-0.8.sh", 'install-qpid-0.8.sh' do
    pre :install, "sudo killall -9 qpidd || true"
    post :install, "sudo chmod +x install-qpid-0.8.sh"
    post :install, "sudo TOOLS_HOME=/usr/tools ./install-qpid-0.8.sh"
  end

  verify do
    has_executable 'qpidd'
    has_executable_with_version('qpidd', '0.8', '--version')
  end
end

package :qpidd_service do 
  requires :qpidd
  transfer "#{File.dirname(__FILE__)}/../config/qpid", 'qpid' do
    pre :install, "sudo adduser qpid --system --no-create-home --disabled-password --disabled-login --group"
    post :install, "sudo mv qpid /etc/init.d/qpid"
    post :install, "sudo chmod +x /etc/init.d/qpid"
  end

  verify do
    has_file '/etc/init.d/qpid'
  end
end

[[:qpidd_dev, 5672],[:qpidd_test, 5673], [:qpidd_production, 5675]].each do |pkg, port|

  package pkg do
    requires :qpidd_service
    
    noop do
      post :install, "sudo ln -sf ./qpid /etc/init.d/qpid#{port}"
      post :install, "sudo update-rc.d qpid#{port} defaults"
      post :install, "sudo /etc/init.d/qpid#{port} stop || true"
      post :install, "sudo /etc/init.d/qpid#{port} start"
      post :install, "sleep 5" # deamon staring and making pid file is a race
    end
    
    verify do 
      has_file "/etc/init.d/qpid#{port}"
      has_file "/var/db/qpidd.#{port}/qpidd.#{port}.pid"
    end
  end
end

package :qpid_commands do
  noop do
    # cleanup the previous install attempts
    pre :install, "rm -f /usr/local/sources/qpid-python-0.8.tar.gz"
    pre :install, "rm -f /usr/local/sbin/qpid-*"
  end

  source "http://apache.deathculture.net//qpid/0.8/qpid-0.8.tar.gz", :custom_dir => 'qpid-0.8' do
    
    custom_install "PPATH=`pwd` && cd tools/src/py && for f in *; do echo \"PYTHONPATH=$PPATH/python:$PPATH/extras/qmf/src/py python $PPATH/tools/src/py/$f \\$@\" | sudo tee /usr/local/sbin/$f; sudo chmod +x /usr/local/sbin/$f; done"
    
  end
  
  verify do 
    has_file "/usr/local/sbin/qpid-stat"
    file_contains '/usr/local/sbin/qpid-stat', '@'
    file_contains '/usr/local/sbin/qpid-stat', 'qpid-0.8'
    has_executable "qpid-stat"
    has_executable "qpid-tool"
  end
end