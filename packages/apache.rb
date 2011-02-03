
package :apache, :provides => :webserver do
  description 'Apache2 web server.'
  apt 'apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 ssl-cert libopenssl-ruby' do
    post :install, 'a2enmod rewrite'
    post :install, 'a2dissite default'
  end
  
end

package :apache2_prefork_dev do
  description 'A dependency required by some packages.'
  apt 'apache2-prefork-dev'
end

package :passenger, :provides => :appserver do
  description 'Phusion Passenger (mod_rails)'
  
  gem_version = '2.2.11'
  
  load_file = '/etc/apache2/mods-available/passenger.load'
  conf_file = '/etc/apache2/mods-available/passenger.conf'
  
  gem 'passenger' do
    version gem_version
    # cleanup any other versions of passenger we had installed
    pre :install, 'gem uninstall passenger -a -x || true'
    pre :install, 'rm -f /etc/apache2/mods-available/passenger.*'
    post :install, 'passenger-install-apache2-module -a'
    post :install, "echo \"LoadModule passenger_module `gem environment gemdir`/gems/passenger-#{gem_version}/ext/apache2/mod_passenger.so\" | sudo tee #{load_file}"
    post :install, "echo \"PassengerRoot `gem environment gemdir`/gems/passenger-#{gem_version}\" | sudo tee #{conf_file}"
    post :install, "echo \"PassengerRuby /usr/bin/ruby1.8\" | sudo tee -a #{conf_file}"
    post :install, 'a2enmod passenger'
    post :install, '/etc/init.d/apache2 restart'
  end
  
  verify do
    has_file "/etc/apache2/mods-available/passenger.load"
    has_process 'apache2'
  end
  
  requires :apache
  requires :apache2_prefork_dev
end