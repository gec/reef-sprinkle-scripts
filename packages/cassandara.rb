package :cassandra_apt do
  
  apt_list = '/etc/apt/sources.list'
  cassandra_sources = %q[
deb http://www.apache.org/dist/cassandra/debian 06x main
deb-src http://www.apache.org/dist/cassandra/debian 06x main
]

  push_text cassandra_sources, apt_list, :sudo => true do
    pre :install, 'true && gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D && gpg --export --armor F758CE318D77295D | sudo apt-key add -'
    pre :install, "true && cat #{apt_list} | grep -v 'cassandra/debian' | tee ~/apt.bak && sudo cp ~/apt.bak #{apt_list}"
    post :install, 'sudo apt-get update'
  end
  
  verify do
    file_contains apt_list, 'cassandra/debian'
    file_contains apt_list, '06x'
  end
end

package :cassandra do
  requires :cassandra_apt
  apt('cassandra')
  
  verify do 
    has_executable 'cassandra-cli'
  end
end