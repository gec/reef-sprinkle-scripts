# Reef Sprinkle Scripts
Sprinkle (https://github.com/crafterm/sprinkle) is a ruby tool that automates the installation of software packages that makes installing and configuring a suite of software onto a server a (hopefully) few step affair. This readme takes you through the setup of a reef_node on totally clean ubunutu 10.0.1 install. Sprinkle is only  responsible for installing and setting up the server level components: qpid, mysql, apache, etc.  Deploying the current reef system is done using a different tool and described in that README.txt 

We are supplying some scripts we use internally to deploy new test and virutal node boxes to help the community get started on linux, not as the only way to setup a reef node. Issues can be opened and may be responded to but we are not in the business of supporting these scripts. 

## Preparing Target Box:

The sprinkle scripts are designed to be idempotent, if run multiple times against the same box it should only install things once. They are also _supposed_ to be able to run against an allready partially deployed server but due to the infinite combinations of configurations available, _no_guarranties_ are made on these scripts working when running against a non clean system. They are primarily tested against a clean server install.

Install ubutnutu 10.0.1 with only OpenSSH server on the target machine. You will need to know the username and password of an "admin" user (has sudo privelges) on that box. That is usually the name you setup as you installed. Make sure that the box has an ssh server running and that the username and password work by logging via ssh. 

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install openssh-server

    # optional but helpful things to install on server
    sudo apt-get install htop screen

## Install Ruby and Gem (locally):

On development machine (machine you will be deploying from) we need to be able to run the ruby gem sprinkle, follow these steps if you dont allready have a working "gem" command on your path. But please dont install the apt-get version of gem, you will live to regret it.

    sudo apt-get install ruby ruby1.8 ruby1.8-dev libopenssl-ruby1.8 wget

Install gem from source, the default gem installation on ubututu is very problematic

    wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
    tar -xf rubygems-1.3.7.tgz
    cd rubygems-1.3.7 && sudo ruby setup.rb && sudo ln -s /usr/bin/gem1.8 /usr/bin/gem

## Install Sprinkle (locally):

Ideally you can use the main version of sprinkle.

    sudo gem install sprinkle
    sprinkle --help

As of 10/8/2010 the commonly published gem sprinkle has some issues with ActiveSuport dependencies. I have forked the project on github with these issues fixed. Once sprinkle is updated beyond 0.3.3 this will be unnecessary.

    sudo apt-get install git-core
    git clone git://github.com/samhendley/sprinkle.git
    sudo gem uninstall sprinkle
    sudo gem install i18n -v 0.4.2 --no-ri --no-rdoc
    sudo gem install jeweler -v 1.5.1 --no-ri --no-rdoc
    sudo gem install rake -v 0.8.7 --no-ri --no-rdoc
    sudo gem install rspec -v 1.2.9 --no-ri --no-rdoc
    cd sprinkle && rake build gemspec && gem build sprinkle.gemspec && sudo gem install sprinkle-0.3.1.gem --no-ri --no-rdoc
    sprinkle --help


## Setting up for public key based sprinkling (Optional):

Generate a set of ssh keys locally on your development machine (if you don't have a set allready):

    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa

This will allow us to do passwordless installs and upgrades on the target machine and in fact is necessary for the "reef" user since we don't plan on giving that user a password so the only way to login as that user is via public key authentication.

NOTE: if the username you are running as now (run the command 'whoami') is not the same as the admin user you will need to replace the `whoami` in add_public_key.rb with the admin user on the target box.

now we will add our public key as an "authorized key" on the target box for both the admin user and the "reef" user we are going to be deploying as. If you are trying to setup a development machine as a reef node you need to set the ip address to your external ip (openssh doesnt listen on localhost adapter)

    # change directory to where you checked out reef-sprinkle-scripts
    cd ~/reef-sprinkle-scripts
    
    nano deploy.rb # change role: reef_node ip address value to target box.
    
    sprinkle -s add_public_key.rb

You should get prompted for the password of the admin user on the target box. If there is a failure there will be a big ruby stack trace error message, that should tell us what command failed. For more information rerun with a "-v" option and all of the output on the server will be printed as well.

If it was successfull (no error messages) then you should be able to run it again and see that you don't get prompted for the admin password, it is necessary to run this step from every "development machine" you plan on deploying from. 

## Configurations:
We have a couple of cofigurations we have prepared, please install the most minimal for your needs. In paticular it will try to install the sun-jvm, which may lead to serious issues if you have another java installed:

* qpid_server.rb:     builds and installs qpid broker and boost 1_45 from source
  - qpid       (apache messaging broker, running on standard port 5672)
  - qpid-tools (python tools to see qpid status, installed to /usr/bin/qpid-*)

* reef_node.rb:       minimal setup to run a reef node (recommended for most users) 
  - everything from qpid_server
  - postgresql (database)
  - sun-jdk    (java vm can be commented out if there is already java on the machine)
  - screen     (utility to do multiple windows in single console)
  
* reef_build_node.rb: minimal setup to rebuild reef from source
  - everything from reef_node
  - protoc     (protobuf compiler)
  - sun-jdk    (need java and xjc, if both of those are on path can be commented out)
  - qpid daemon(running on a differnt port for testing 5673)
  - maven3     (from "source" not the ubunutu package which is quite old)
  
If there is any doubt what is going to be installed, adding the "-c -t" arguments will have screen tell you a bit about the package hierarchy and then have it "dry run" the install and just check which packages it would install.

## Sprinkle a configuration onto the target
After installing sprinkle and preparing a "target box" with a clean copy of ubunutu we can run the sprinkle commands to load sets of software onto the target in an automated fashion.

    # install git and check out the sprinkle files
    sudo apt-get install git
    git co git://github.com/gec/reef-sprinkle-scripts.git
    # change directory to where you checked out reef-sprinkle-scripts
    cd ~/reef-sprinkle-scripts
    
    nano deploy.rb # change role: target_box ip address value to point to target box
    sprinkle -s reef_node.rb -v

This may take a long time, especially if packages are being compiled from source (qpid in particular), i've found it useful to be logged onto the box and run htop to see that progress is being made lots of applications should be installed and if anything fails we need to look at the error messages returned to us. There are a few issue that can be fixed by running again, try running it a second time with the -v flag if there are problems (but please post the errors anyways)

If the process completes succesfully we have now installed all of the "server level" software. Note that though we may have installed a database server, that doesn't mean we have setup the users or database tables necessary for any specific installation of reef, make sure to read the documents that came with your distribution.

# Troubleshooting:

If errors occur the best thing to do is rerun it with the -v option turned on, it should report the line that failed and the best bet is to try running that command manually using ssh, that is usually the best plan. If that fails the "packages" are really just wrappers around shell commands. It is very easy to read the "recipe" out of the package file and run them by hand, sometimes it really is just broken.

# Known issues:

### Protoc

If running a desktop version of ubuntu you may have the wrong version of protoc installed by default, follow these steps if that appears to be the case

    execute protoc --version to determine what version of procobuf-compiler you have,
    # if it is not 2.3.0, follow these steps to remove the wrong version and install the correct one
    sudo dpkg -r protobuf-compiler 
    wget http://protobuf.googlecode.com/files/protobuf-2.3.0.tar.gz
    tar -xf protobuf-2.3.0.tar.gz
    cd protobuf-2.3.0
    ./configure
    make
    sudo make install
    sudo ldconfig /usr/local/lib