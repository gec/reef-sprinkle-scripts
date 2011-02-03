package :boost_1_43 do 
  requires :build_essentials

  transfer "#{File.dirname(__FILE__)}/../installer_scripts/install-boost_1_43.sh", 'install-boost_1_43.sh' do
    post :install, "sudo mkdir -p /usr/tools/"
    post :install, "sudo chmod -R 777 /usr/tools/"
    post :install, "sudo chmod +x install-boost_1_43.sh"
    post :install, "sudo TOOLS_HOME=/usr/tools ./install-boost_1_43.sh"
    post :install, "sudo chmod -R 777 /usr/tools/"
  end

  verify do
    has_file '/usr/tools/boostlib/boost_1_43/Linux_i686/libboost_thread.so'
  end
end
package :boost_1_41 do 
  requires :build_essentials

  transfer "#{File.dirname(__FILE__)}/../installer_scripts/install-boost_1_41.sh", 'install-boost_1_41.sh' do
    post :install, "sudo mkdir -p /usr/tools/"
    post :install, "sudo chmod -R 777 /usr/tools/"
    post :install, "sudo chmod +x install-boost_1_41.sh"
    post :install, "sudo TOOLS_HOME=/usr/tools ./install-boost_1_41.sh"
    post :install, "sudo chmod -R 777 /usr/tools/"
    # install it to lib, makes it easier to keep the LD path correct
    post :install, "sudo cp /usr/tools/boostlib/boost_1_41/Linux_i686/* /usr/lib/"
  end

  verify do
    has_file '/usr/lib/libboost_system.so.1.41.0'
  end
end

package :boost_1_43_arm do 
  requires :build_essentials

  transfer "#{File.dirname(__FILE__)}/../installer_scripts/install-boost_1_43_arm.sh", 'install-boost_1_43_arm.sh' do
    post :install, "mkdir -p /usr/tools/"
    post :install, "chmod -R 777 /usr/tools/"
    post :install, "chmod +x install-boost_1_43_arm.sh"
    post :install, "sudo TOOLS_HOME=/usr/tools ./install-boost_1_43_arm.sh"
    post :install, "chmod -R 777 /usr/tools/"
  end

  verify do
    has_file '/usr/tools/boostlib/boost_1_43/pc_linux_arm/libboost_thread.so'
  end
end

package :boost_1_45 do 
  requires :build_essentials

  transfer "#{File.dirname(__FILE__)}/../installer_scripts/install-boost_1_45.sh", 'install-boost_1_45.sh' do
    post :install, "sudo mkdir -p /usr/tools/"
    post :install, "sudo chmod -R 777 /usr/tools/"
    post :install, "sudo chmod +x install-boost_1_45.sh"
    post :install, "sudo TOOLS_HOME=/usr/tools ./install-boost_1_45.sh"
    post :install, "sudo chmod -R 777 /usr/tools/"
    post :install, "sudo ldconfig /usr/tools/boostlib/boost_1_45/Linux_i686"
    post :install, "echo '/usr/tools/boostlib/boost_1_45/Linux_i686' | sudo tee /etc/ld.so.conf.d/boost_1_45.conf"
  end

  verify do
    has_file '/usr/tools/boostlib/boost_1_45/Linux_i686/libboost_system.so.1.45.0'
    has_file '/etc/ld.so.conf.d/boost_1_45.conf'
  end
end