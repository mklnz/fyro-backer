require 'spec_helper'

describe App do
  let(:test_config_path) { "#{File.expand_path("../", __FILE__)}/test_config.yml" }
  
  it "initializes with config" do
    app = App.new(test_config_path)
    app.db_engine.should eq("postgresql")
    app.hostname.should eq("localhost")
    app.username.should eq("test_user")
    app.database.should eq("test_db")
    app.output_dir.should eq("/tmp")
  end
  
  describe "backups" do
    include FakeFS::SpecHelpers
    
    before(:each) do
      @app = App.new
      @app.hostname = "localhost"
      @app.username = "test_user"
      @app.database = "test_db"
      @app.output_dir = Dir.tmpdir
      @app.stub(:dump_db) {
        File.open("#{Dir.tmpdir}/#{@app.output_format}.sql", "w") { |file| file.write("") }
      }
      @app.stub(:compress) {
        File.open("#{Dir.tmpdir}/#{@app.output_format}.zip", "w") { |file| file.write("") }
      }
    end
    
    it "dumps to correct location" do
      year = Time.now.year.to_s
      month = Time.now.month.to_s
    
      @app.run

      # Check year
      File.exist?("#{@app.output_dir}/#{year}").should be_true
      # Check month
      File.exist?("#{@app.output_dir}/#{year}/#{month}").should be_true
      # Check dump file
      File.exist?("#{@app.output_dir}/#{year}/#{month}/#{@app.output_format}.zip").should be_true
    end
  
    it "cleans up old backups" do
      # Make some backups 1st month
      Timecop.freeze(Time.now.beginning_of_month)
      
      28.times do
        @app.backup_time = Time.now
        @app.run
        Timecop.freeze(1.day.from_now)
      end
      
      # Jump to 2nd month
      Timecop.freeze(1.month.from_now.beginning_of_month)
      
      28.times do
        @app.backup_time = Time.now
        @app.run
        Timecop.freeze(1.day.from_now)
      end

      # Jump to 3rd month
      Timecop.freeze(1.month.from_now.beginning_of_month)
      @app.backup_time = Time.now
      @app.run
      
      # Should clean first month
      two_months_ago_year = 2.months.ago.year.to_s
      two_months_ago_month = 2.months.ago.month.to_s
      
      # Back up folder should now contain only 1 backup
      (Dir.entries("#{@app.output_dir}/#{two_months_ago_year}/#{two_months_ago_month}").size - 2).should eq(1)
      
      # Second month untouched
      one_month_ago_year = 1.month.ago.year.to_s
      one_month_ago_month = 1.month.ago.month.to_s
      (Dir.entries("#{@app.output_dir}/#{one_month_ago_year}/#{one_month_ago_month}").size - 2).should eq(28)
      
      Timecop.return
    end
  end

end
