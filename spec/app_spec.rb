require 'spec_helper'

describe App do
  it "initializes with config" do
    app = App.new("#{File.expand_path("../", __FILE__)}/test_config.yml")
    app.hostname.should eq("localhost")
    app.user.should eq("test_user")
    app.database.should eq("test_db")
    app.output_dir.should eq("/tmp")
  end
  
end
