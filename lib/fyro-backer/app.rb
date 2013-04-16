require 'net/sftp'
require 'yaml'

module Fyro; end

module Fyro::Backer
  
  class App
    attr_accessor :hostname, :user, :database, :output_dir
  
    def initialize(config_file)
      config = YAML.load_file(config_file)
      config.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
    
    def full_output_path
      year = Time.now.year.to_s
      month = Time.now.month.to_s
      "#{self.output_dir}/#{year}/#{month}"
    end
  
    def run
      prepare_dir
      
      timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
    
      dump_command = "pg_dump -U #{self.user} -h #{self.hostname} #{self.database} > /tmp/#{timestamp}.sql"
      `#{dump_command}`
      
      `tar zcvf /tmp/#{timestamp}.tar.gz /tmp/#{timestamp}.sql`
      `mv /tmp/#{timestamp}.tar.gz #{self.full_output_path}`
      `rm /tmp/#{timestamp}.sql`
    end
    
    private
    def prepare_dir
      `mkdir -p #{self.full_output_path}`
    end
    
    def clean_up
      
      
    end
  end
  
end
