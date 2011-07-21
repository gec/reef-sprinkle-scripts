

require File.join(File.dirname(__FILE__),'common.rb')

policy :reef_node, :roles => [:target_box] do
  requires :dnp3_library_32
  requires :screen
  requires :java
  requires :postgresql
  requires :qpidd
  requires :qpidd_dev
  requires :qpid_commands
end

deploy
