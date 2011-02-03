default_run_options[:pty] = true

# where our ssh_key is kept, update if moved/names in a nonstandard place
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")] 

# the admin user we will run the commands as on the server, needs sudo priveleges
# defaults to the current user
set :user, `whoami`.strip

# machine we want to install the reef node software stack on
role :target_box, "192.168.100.34"

# we can also have a list of machines to install them all in parrell
#role :target_box, "192.168.100.80", "192.168.100.70", "192.168.100.14"
