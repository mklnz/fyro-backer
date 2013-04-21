require 'yaml'

module Fyro; end

module Fyro::Backer
  
  class App
    attr_accessor :hostname, :user, :database, :output_dir
  
    def initialize(config_file = nil)
      unless config_file.nil?
        config = YAML.load_file(config_file)
        config.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
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
      FileUtils.mkdir_p self.full_output_path
      dump_db
      compress
      
      FileUtils.mv("#{Dir.tmpdir}/#{self.timestamp}.zip", self.full_output_path)
      FileUtils.rm("#{Dir.tmpdir}/#{self.timestamp}.sql")
      clean_up
    end
    
    private
    def dump_db
      `pg_dump -U #{self.user} -h #{self.hostname} #{self.database} > #{Dir.tmpdir}/#{self.timestamp}.sql`
    end
    
    def compress
      Zip::ZipFile.open("#{Dir.tmpdir}/#{self.timestamp}.zip", Zip::ZipFile::CREATE) do |zipfile|
        zipfile.add("#{self.timestamp}.sql", "#{Dir.tmpdir}/#{self.timestamp}.sql")
      end
    end
    
    def clean_up
      
    end
  end
  
end
