package :ruby do
  description 'Ruby Virtual Machine'
  version '1.8.6'
  patchlevel '369'
  source "ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-#{version}-p#{patchlevel}.tar.gz" # implicit :style => :gnu
  requires :ruby_dependencies
  verify do
    has_executable 'ruby'
  end
end

package :ruby_dependencies do
  description 'Ruby Virtual Machine Build Dependencies'
  apt %w( bison zlib1g-dev libssl-dev libreadline5-dev libncurses5-dev file ruby1.8-dev)
end

package :rubygems do
  description 'Ruby Gems Package Management System'
  version '1.3.7'
  source "http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz" do
    custom_install 'ruby setup.rb'
    post :install, "ln -s /usr/bin/gem1.8 /usr/bin/gem"
  end
  requires :ruby
  verify do
    has_executable 'gem'
  end

end

package :rake do
  gem 'rake'
  verify do 
    has_executable 'rake'
  end 
end

package :god do
  gem 'god'
  verify do
    has_executable 'god'
  end  
end
package :bundler do
  gem 'bundler'
  verify do
    has_executable 'bundle'
  end  
end

package :gem_ssh do
  gem 'net-ssh'
end

package :god_service do 
  requires :god
  transfer "#{File.dirname(__FILE__)}/../config/god", 'god' do
    post :install, "sudo mv god /etc/init.d/god"
    post :install, "sudo chmod +x /etc/init.d/god"
    post :install, "sudo update-rc.d god defaults"
  end

  verify do
    has_file '/etc/init.d/god'
  end
end