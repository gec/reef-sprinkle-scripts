package :dnp3_java_build do
  apt 'swig'
  requires :java
  requires :mvn3
end

package :dnp3_sprinkle do
  noop do
    post :install, "rm -rf dnp3_sprinkle"
    post :install, "true && git clone git://github.com/greenenergycorp/dnp3.git dnp3_sprinkle"
  end
  
  verify do
    has_file '~/dnp3_sprinkle/rakefile.rb'
  end
end

package :dnp3_java do
  requires :dnp3_build, :dnp3_java_build, :dnp3_sprinkle
  noop do
    post :install, "true && cd dnp3_sprinkle && git checkout 0.9.2"
    post :install, "true && cd dnp3_sprinkle && TOOLS_HOME=/usr/tools JAVA_HOME=/usr/lib/jvm/java-6-openjdk rake dnp3java:package"
  end

  verify do
    has_file '~/dnp3_sprinkle/DNP3Java/dnp3java.jar'
  end
end

package :dnp3_java_upload do
  requires :dnp3_java
  
  noop do
    post :install, "JAVA_HOME=/usr/lib/jvm/java-6-openjdk sudo gem install buildr --version '1.4.2' --no-rdoc --no-ri "
    post :install, "true && cd dnp3_sprinkle/DNP3Java && buildr upload"
  end
end

package :dnp3_build do
  requires :build_essentials
  requires :cpp_build_tools
  requires :cpp_test_tools
  requires :git
  requires :svn
  requires :wget
  requires :rubygems
  requires :rake
  requires :boost_1_43
end

package :dnp3_library_32 do

  download_name = "libdnp3java.so.1.0.0-lucid-x32..tar.gz"
  download_url = "http://dnp3.googlecode.com/files/#{download_name}"
  library_name = "libdnp3java.so.1.0.0"
  
  noop do
    pre :install, "wget #{download_url}"
    pre :install, "sudo mv #{download_name} /lib/#{library_name} && sudo ln -s /lib/#{library_name} /lib/libdnp3java.so"
  end
  
  verify do
    has_file "/lib/#{library_name}"
    has_file "/lib/libdnp3java.so"
  end
end

#package :dnp3_library_64 do
#
#  download_url = "http://dnp3.googlecode.com/files/libdnp3java-0.9.4-lucid-x64.tar.gz"
#  library_name = "libdnp3java.so.0.9.4"
#  
#  source download_url do
#    custom_install 'sudo mv #{library_name} /lib'
#    #custom_install 'sudo mv #{library_name} /lib && sudo ln -s /lib/#{library_name} /lib/libdnp3java.so'
#  end
#end
