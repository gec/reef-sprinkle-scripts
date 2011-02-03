require File.join(File.dirname(__FILE__),'common.rb')

policy :dnp3, :roles => :dnp3_java_slave do
  requires :dnp3_build
  requires :dnp3_java
  requires :dnp3_java_upload
end

deploy