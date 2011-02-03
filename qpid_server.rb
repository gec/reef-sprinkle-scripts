
require File.join(File.dirname(__FILE__),'common.rb')

policy :qpid_server, :roles => [:target_box] do
  requires :qpidd
  requires :qpidd_dev
  requires :qpid_commands
end

deploy
