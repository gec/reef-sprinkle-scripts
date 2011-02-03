
$user = 'reef'

require File.join(File.dirname(__FILE__),'common.rb')

policy :anemone_node, :roles => [:anemone_node] do
  requires :bundler
  requires :god
  requires :god_service
  requires :mysql
  requires :ruby_mysql_driver
  requires :passenger
end

deploy
