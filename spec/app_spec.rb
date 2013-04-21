require 'spec_helper'

describe App do
  let(:test_config_path) { "#{File.expand_path("../", __FILE__)}/test_config.yml" }
  
  it "initializes with config" do
    app = App.new(test_config_path)
    app.hostname.should eq("localhost")
    app.user.should eq("test_user")
    app.database.should eq("test_db")
    app.output_dir.should eq("/tmp")
  end
  
  describe "backups" do
    include FakeFS::SpecHelpers
    
    before(:each) do
      @app = App.new
      @app.hostname = "localhost"
      @app.user = "test_user"
      @app.database = "test_db"
      @app.output_dir = Dir.tmpdir
      @app.stub(:dump_db) {
        File.open("#{Dir.tmpdir}/#{@app.timestamp}.sql", "w") { |file| file.write("") }
      }
      @app.stub(:compress) {
        File.open("#{Dir.tmpdir}/#{@app.timestamp}.zip", "w") { |file| file.write("") }
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
      File.exist?("#{@app.output_dir}/#{year}/#{month}/#{@app.timestamp}.zip").should be_true
    end
  
    it "cleans up old backups" do
      # Make some backups 1st month
      Timecop.freeze(Time.now.beginning_of_month)
      
      28.times do
        @app.run
        Timecop.freeze(1.day.from_now)
      end
      
      # Jump to 2nd month
      Timecop.freeze(1.month.from_now.beginning_of_month)
      
      28.times do
        @app.run
        Timecop.freeze(1.day.from_now)
      end

      # Jump to 3rd month
      Timecop.freeze(1.month.from_now.beginning_of_month)
      @app.run
      
      # Should clean first month
      two_months_ago_year = 2.months.ago.year.to_s
      two_months_ago_month = 2.months.ago.month.to_s
      
      Dir.chdir("#{@app.output_dir}/#{two_months_ago_year}/#{two_months_ago_month}")
      Dir["**/*"].length.should eq(1)
            
      Timecop.return
    end
  end

end
