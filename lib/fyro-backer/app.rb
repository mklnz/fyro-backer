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
    
    def timestamp
      Time.now.strftime("%Y%m%d_%H%M%S")
    end
  
    def run
      `mkdir -p #{self.full_output_path}`
      dump_db
      `tar zcvf /tmp/#{self.timestamp}.tar.gz /tmp/#{self.timestamp}.sql`
      `mv /tmp/#{self.timestamp}.tar.gz #{self.full_output_path}`
      `rm /tmp/#{self.timestamp}.sql`
    end
    
    private
    def dump_db
      `pg_dump -U #{self.user} -h #{self.hostname} #{self.database} > /tmp/#{self.timestamp}.sql`
    end
    
    def clean_up
      
    end
  end
  
end
