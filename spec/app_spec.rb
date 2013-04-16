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
  
  it "dumps to correct location", fakefs: true do    
    app = App.new(test_config_path)
    year = Time.now.year.to_s
    month = Time.now.month.to_s
    

    app.stub(:dump_db) {
      File.open("/tmp/#{app.timestamp}.sql", "w") { |file| file.write("") }
    }
    
    app.run

    # Check year
    File.exist?("#{app.output_dir}/#{year}").should be_true
    # Check month
    File.exist?("#{app.output_dir}/#{year}/#{month}").should be_true
    # Check dump file
    File.exist?("#{app.output_dir}/#{year}/#{month}/#{app.timestamp}.tar.gz").should be_true
  end
end
