
# who we want to add the our public key as an authorized user for
$users = [`whoami`.strip]

require File.join(File.dirname(__FILE__),'common.rb')

policy :add_public_key, :roles => [:target_box] do
  requires :add_my_key_to_authorized
end

deploy
