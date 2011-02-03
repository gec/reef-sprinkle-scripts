# sprinkle is a ruby tool that automates the installation of software packages that makes installing
# and configuring a suite of software onto a server a (hopefully) few step affair. This readme takes
# you through the setup of a reef_node on totally clean ubunutu 10.0.1 install. Sprinkle is only 
# responsible for installing and setting up the server level components: qpid, mysql, apache, etc. 
# Deploying the current reef system is done using a different tool and described in that README.txt

# Install ubutnutu 10.0.1 with only OpenSSH server on the target machine. You will need to know the
# username and password of an "admin" user (has sudo privelges) on that box. That is usually the 
# name you setup as you installed. Make sure that the box has an ssh server running and that the username
# and password work by logging via ssh. 

# execute protoc --version to determine what version of procobuf-compiler you have,
# if it is not 2.3.0, follow these steps to remove the wrong version and install the correct one
# sudo dpkg -r protobuf-compiler 
# wget http://protobuf.googlecode.com/files/protobuf-2.3.0.tar.gz
# tar -xf protobuf-2.3.0.tar.gz
# cd protobuf-2.3.0
# ./configure
# make
# sudo make install
# sudo ldconfig /usr/local/lib

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install openssh-server




# optional but helpful things to install on server
sudo apt-get install htop screen

# install subversion and check out the sprinkle files
sudo apt-get install subversion
svn co https://svn.plymouthsystems.com:8443/svn/utility/trunk/install_scripts/sprinkle sprinkle


# On development machine install the gem sprinkle (which also installs capistrano)

sudo apt-get install ruby ruby1.8 ruby1.8-dev libopenssl-ruby1.8 wget

# install gem from source, the default gem installation on ubututu is very problematic
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
tar -xf rubygems-1.3.7.tgz
cd rubygems-1.3.7 && sudo ruby setup.rb && sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

# as of 10/8/2010 the commonly published gem sprinkle has some issues. I have forked the
# project on github with these issues fixed. Once sprinkle is updated beyond 0.3.1 this will
# be unnecessary.
sudo apt-get install git-core
git clone git://github.com/samhendley/sprinkle.git
sudo gem install i18n -v 0.4.2 --no-ri --no-rdoc
sudo gem install jeweler -v 1.5.1 --no-ri --no-rdoc
sudo gem install rake -v 0.8.7 --no-ri --no-rdoc
sudo gem install rspec -v 1.2.9 --no-ri --no-rdoc
cd sprinkle && rake build gemspec && gem build sprinkle.gemspec && sudo gem install sprinkle-0.3.1.gem --no-ri --no-rdoc

# try running sprinkle --help to make sure it is correctly installed.

# Generate a set of ssh keys locally on your development machine (if you don't have a set allready):

ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

# This will allow us to do passwordless installs and upgrades on the target machine and in fact is necessary
# for the "reef" user since we don't plan on giving that user a password so the only way to login as that
# user is via public key authentication.

# NOTE: if the username you are running as now (run the command 'whoami') is not the same as the admin user
# you will need to replace the `whoami` in add_public_key.rb with the admin user on the target box.

# now we will add our public key as an "authorized key" on the target box for both the admin user and the 
# "reef" user we are going to be deploying as. If you are trying to setup a development machine as a reef 
# node you need to set the ip address to your external ip (openssh doesnt listen on localhost adapter)


# change directory to where you checked out the install_scripts/sprinkle
cd ~/sprinkle

nano deploy.rb # change role: reef_node ip address value to target box.

sprinkle -s add_public_key.rb

# You should get prompted for the password of the admin user on the target box. If there is a failure there
# will be a big ruby stack trace error message, that should tell us what command failed. For more information
# rerun with a "-v" option and all of the output on the server will be printed as well.

# If it was successfull (no error messages) then you should be able to run it again and see that you don't get
# prompted for the admin password, it is necessary to run this step from every "development machine" you plan on 
# deploying from. 


# Now that we have made ourselves passwordless users we can install the rest of the reef software:
sprinkle -s reef_node.rb -v

# this may take a long time, i've found it useful to be logged 
# onto the box and run htop to see that progress is being made
# lots of applications should be installed and if anything fails 
# we need to look at the error messages returned to us. There are a 
# few issue that can be fixed by running again, try running it a second time
# with the -v flag if there are problems (but please post the errors anyways)

# If the process completes succesfully we have now installed all of the core software to run a reef_node, now
# we need to install the current reef software on that note using capistrano, please see that README.txt for 
# those instructions.


