require 'thor'

module Fyro; end
  
module Fyro::Backer
  
  class CLI < Thor
    
    desc "backup [config]", "Runs and stores a single backup"
    def backup(config_path)
      fb = Fyro::Backer::App.new(config_path)
      fb.run
    end
    
    desc "version", "Prints version information"
    def version
      puts Fyro::Backer::VERSION
    end
  end
  
end
