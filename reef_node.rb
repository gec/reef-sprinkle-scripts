

require File.join(File.dirname(__FILE__),'common.rb')

policy :reef_node, :roles => [:reef_node] do
  requires :screen
  requires :java
  requires :postgresql
  requires :qpidd
  requires :qpidd_dev
  requires :qpid_commands
end

deploy
