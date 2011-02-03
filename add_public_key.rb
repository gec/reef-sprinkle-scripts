

# who we want to add the our public key as an authorized user for
$users = [`whoami`.strip]

require File.join(File.dirname(__FILE__),'common.rb')

policy :reef_node, :roles => [:reef_node] do
  requires :add_my_key_to_authorized
end

deploy
