
Dir["#{File.dirname(__FILE__)}/packages/*.rb"].each do |f|
  require f
end

def deploy
  deployment do
  
    # mechanism for deployment
    delivery :capistrano do
      recipes 'deploy'
    end
    #delivery :local
  
    # source based package installer defaults
    source do
      prefix   '/usr/local'
      archives '/usr/local/sources'
      builds   '/usr/local/build'
    end
  
  end
end
