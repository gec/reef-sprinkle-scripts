package :git do
  apt 'git-core'
  verify do
    has_executable 'git'
  end
end

package :svn do
  apt 'subversion'
  verify do
    has_executable 'svn'
  end
end

package :wget do
  apt 'wget'
  verify do
    has_executable 'wget'
  end
end

package :screen do
  apt 'screen'
  transfer "#{File.dirname(__FILE__)}/../config/.screenrc", '.screenrc'
  
  verify do
    has_executable 'screen'
    has_file '~/.screenrc'
  end
end

package :build_essentials do
  description 'Build tools'
  apt 'build-essential' do
    # Update the sources and upgrade the lists before we build essentials
    pre :install, 'apt-get update'
  end

  verify do
    has_executable 'g++'
  end
end

package :protoc do 
  source "http://protobuf.googlecode.com/files/protobuf-2.3.0.tar.gz" do
    post :install, "ldconfig /usr/local/lib/"
  end
  verify do
    has_executable 'protoc'
    has_executable_with_version('protoc', '2.3.0', '--version')
  end  
end