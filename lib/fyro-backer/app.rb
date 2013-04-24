require 'yaml'

module Fyro; end

module Fyro::Backer
  
  class App
    attr_accessor :backup_time, :db_engine, :hostname, :username, :password, :database, :output_dir
  
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
    
    def output_format
      timestamp = self.backup_time.strftime("%Y%m%d_%H%M%S")
      "#{timestamp}_#{self.database}"
    end
  
    def run
      FileUtils.mkdir_p self.full_output_path
      dump_db
      compress
      
      FileUtils.mv("#{Dir.tmpdir}/#{self.output_format}.zip", self.full_output_path)
      FileUtils.rm("#{Dir.tmpdir}/#{self.output_format}.sql")
      
      clean_up
    end
    
    private
    def dump_db
      if self.db_engine == "postgresql"
        `pg_dump -U #{self.username} -w -h #{self.hostname} #{self.database} > #{Dir.tmpdir}/#{self.output_format}.sql`
      end
      
      if self.db_engine == "mysql"
        segment = {}
        if self.password.nil?
          segment[:password] = nil
        else
          segment[:password] = " -p#{self.password} "
        end
        
        `mysqldump -u #{self.username}#{segment[:password]}-h #{self.hostname} #{self.database} > #{Dir.tmpdir}/#{self.output_format}.sql`
      end
    end
    
    def compress
      Zip::ZipFile.open("#{Dir.tmpdir}/#{self.output_format}.zip", Zip::ZipFile::CREATE) do |zipfile|
        zipfile.add("#{self.output_format}.sql", "#{Dir.tmpdir}/#{self.output_format}.sql")
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
