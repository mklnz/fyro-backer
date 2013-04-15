require 'net/sftp'

module Fyro; end

module Fyro::Backer
  
  class App
    attr_accessor :hostname, :user, :database, :remote_dir, :remote_user, :remote_password
  
    def initialize(config_file)
      config = YAML.load_file(config_file)
      config.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  
    def run
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
    
      dump_command = "pg_dump -U #{self.user} -h #{self.hostname} #{self.database} > #{timestamp}.sql"
      `#{dump_command}`
    end
  
    private
    def dump
    end
  
    def upload
    
    end
  end
  
end
