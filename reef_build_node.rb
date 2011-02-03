
require File.join(File.dirname(__FILE__),'common.rb')

policy :reef_build_node, :roles => [:target_box] do
  requires :screen
  requires :protoc
  requires :java
  requires :mvn3
  requires :postgresql
  requires :qpidd
  requires :qpidd_dev
  requires :qpidd_test
  requires :qpid_commands
end

deploy
