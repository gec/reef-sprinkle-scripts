package :java_sun do
  
  apt('python-software-properties')

  apt('sun-java6-jdk') do
    pre :install, 'echo "sun-java6-jdk shared/accepted-sun-dlj-v1-1 boolean true" | sudo -E debconf-set-selections'
    pre :install, "sudo add-apt-repository 'deb http://archive.canonical.com/ lucid partner' && sudo apt-get update"
  end

  verify do
    has_executable 'java'
    has_executable 'xjc'
  end  
  
end

package :java do

  apt('openjdk-6-jdk')

  verify do
    has_executable 'java'
    has_executable 'xjc'
  end

end

package :mvn3 do
  source "http://mirrors.ibiblio.org/apache//maven/binaries/apache-maven-3.0.3-bin.tar.gz", :custom_dir => 'apache-maven-3.0.3' do
    pre :install, "sudo rm -f `which mvn`"
    custom_install "PPATH=`pwd` JHOME=$JAVA_HOME && echo \"JAVA_HOME=$JHOME $PPATH/bin/mvn \\$@\" | sudo tee /usr/local/sbin/mvn && sudo chmod +x /usr/local/sbin/mvn"
  end
  
  verify do
    has_executable 'mvn'
    has_executable_with_version('mvn', '3.0.3', '--version')
  end  
end


package :sbt do 
  requires :java
  noop do 
    post :install, "wget http://simple-build-tool.googlecode.com/files/sbt-launch-0.7.4.jar"
    post :install, "cp sbt-launch-0.7.4.jar /usr/lib/sbt-launch.jar"
  end
  
  sbt_text = 'java -Xmx1024M -XX:MaxPermSize=512M -jar /usr/lib/sbt-launch.jar "$@"'
  
  push_text sbt_text, '/usr/bin/sbt', :sudo => true do 
    post :install, "chmod +x /usr/bin/sbt"
  end
  
  verify do
    has_executable 'sbt'
  end
end