require 'yaml'

module Fyro; end

module Fyro::Backer
  
  class App
    attr_accessor :backup_time, :hostname, :user, :password, :database, :output_dir
  
    def initialize(config_file = nil)
      self.backup_time = Time.now
      
      unless config_file.nil?
        config = YAML.load_file(config_file)
        config.each do |key, value|
          instance_variable_set("@#{key}", value)
        end
      end
    end
    
    def full_output_path
      year = self.backup_time.year.to_s
      month = self.backup_time.month.to_s
      "#{self.output_dir}/#{year}/#{month}"
    end
    
    def timestamp
      self.backup_time.strftime("%Y%m%d_%H%M%S")
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
      segment = {}
      if self.password.nil?
        segment[:password] = nil
      else
        segment[:password] = " -W#{self.password}"
      end
      
      `pg_dump -U #{self.user}#{segment[:password]} -h #{self.hostname} #{self.database} > #{Dir.tmpdir}/#{self.timestamp}.sql`
    end
    
    def compress
      Zip::ZipFile.open("#{Dir.tmpdir}/#{self.timestamp}.zip", Zip::ZipFile::CREATE) do |zipfile|
        zipfile.add("#{self.timestamp}.sql", "#{Dir.tmpdir}/#{self.timestamp}.sql")
      end
    end
    
    def clean_up
      # If this is the first backup of the month, then clean the folder 2 months earlier
      if (Dir.entries(self.full_output_path).size - 2) == 1
        
        year = 2.months.ago.year.to_s
        month = 2.months.ago.month.to_s
        
        clean_path = "#{self.output_dir}/#{year}/#{month}"
        
        if Dir.exists?(clean_path) && (Dir.entries(clean_path).size - 2) > 1
          files_arr = Dir.entries(clean_path)
          
          files_arr.each do |f|
            file = File.join(clean_path, f)
            
            if !File.directory?(file) && files_arr.last != f
              File.delete(file) 
            end
          end
        end
      end
    end
  end
  
end
