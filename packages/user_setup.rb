
if not $users and not $user
  puts "$user not specified, make_user tasks not available"
else
  $users = [$user] unless $users
  # we build lots of pseudo packages, one for each user we want to operate on
  $users.each do |user|
    package "create_user_#{user}" do
      noop do
        pre :install, "groupadd -f #{user}"
        pre :install, "adduser -s /bin/bash -m -g #{user} #{user} || true"
      end
      verify do
        has_file "/home/#{user}/.bashrc"
      end
    end
    
    package "create_ssh_dirs_#{user}" do
      requires "create_user_#{user}"
      noop do
        pre :install, "mkdir -p /home/#{user}/.ssh"
        pre :install, "touch /home/#{user}/.ssh/id_rsa"
        pre :install, "touch /home/#{user}/.ssh/id_rsa.pub"
        pre :install, "touch /home/#{user}/.ssh/authorized_keys"
        pre :install, "chown -R #{user}:#{user} /home/#{user}/.ssh/"
        pre :install, "chmod 0600 /home/#{user}/.ssh/id_rsa"
      end
    
      verify do
        has_file "/home/#{user}/.ssh/id_rsa.pub"
        has_file "/home/#{user}/.ssh/authorized_keys"
      end
    end
    
    
    package "generate_private_ssh_keys_#{user}" do
      requires "create_ssh_dirs_#{user}"
      noop do
        pre :install, "ssh-keygen -t rsa -N '' -f /home/#{user}/.ssh/id_rsa"
      end
    
      verify do
        has_file "/home/#{user}/.ssh/id_rsa"
      end
    end
    
    local_public_key_path = File.join(ENV["HOME"], ".ssh", "id_rsa.pub")
    if File.exists?(local_public_key_path)
  
      package "add_my_key_to_authorized_#{user}" do
        requires "create_ssh_dirs_#{user}", "update_sudoers_#{user}"
        
        config_file = "/home/#{user}/.ssh/authorized_keys"
        config_text = File.open(local_public_key_path).read.lstrip
      
        push_text config_text, config_file, :sudo => false
      
        verify do
          file_contains config_file, config_text.slice(0,100)
        end
      end
      
    else
      package "add_my_key_to_authorized_#{user}" do
      end
      puts "no public key at: #{local_public_key_path} so adding keys is unavailable"
    end
    
    package "update_sudoers_#{user}" do
      config_file = "/etc/sudoers"
      config_text = "#{user} ALL=NOPASSWD: ALL"
    
      push_text config_text, config_file, :sudo => true
    
      verify do
        file_contains config_file, config_text
      end
    end
  end
  package :add_my_key_to_authorized do
    $users.each do |user|
      requires "add_my_key_to_authorized_#{user}"
    end
  end
  
  package :make_user do
    $users.each do |user|
      requires "create_user_#{user}"
      requires "generate_private_ssh_keys_#{user}"
    end
  end
end
