
require File.join(File.dirname(__FILE__),'common.rb')

policy :dnp3_hudson, :roles => :dnp3_hudson do
  requires :peach
  requires :hudson
  requires :dnp3_build
  requires :dnp3_java
  
  requires :gem_ssh # for the upload to arm
  requires :arm_cross_compiler
  requires :boost_1_43_arm
end

deploy
