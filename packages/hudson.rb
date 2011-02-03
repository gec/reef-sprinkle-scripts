package :hudson_apt do
  requires :wget
  apt_list = '/etc/apt/sources.list'

  push_text 'deb http://pkg.hudson-labs.org/debian binary/', apt_list, :sudo => true do
    pre :install, 'wget -q -O - http://pkg.hudson-labs.org/debian/hudson-labs.org.key | sudo apt-key add -'
    post :install, 'sudo apt-get update'
  end
  verify do
    file_contains apt_list, 'pkg.hudson-labs.org'
  end
end

package :hudson_app do 
  requires :java, :hudson_apt

  apt('hudson')

  verify do
    has_file '/etc/init.d/hudson'
  end
  
end

package :hudson do 
  requires :hudson_app
  # only necessary to update the --prefix=/hudson setting, the replace_text function didn't work
  transfer 'config/hudson', 'hudson' do
    post :install, 'mv hudson /etc/default/hudson'
  end

    
  verify do
    file_contains '/etc/default/hudson', 'prefix'
  end
  
end